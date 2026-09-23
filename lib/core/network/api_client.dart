import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:factus_app/core/constants/app_config.dart';
import 'package:factus_app/core/exceptions/app_exception.dart';
import 'package:factus_app/core/network/token_storage.dart';
import 'package:factus_app/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';

class ApiClient {
  late final Dio dio;
  final TokenStorage tokenStorage;

  ApiClient({required this.tokenStorage}) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // RECOMENDACIÓN: SSL Pinning / Validar Certificado
    _setupSSLValidation();

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await tokenStorage.getAccessToken();
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          AppLogger.i('📡 Petición: [${options.method}] ${options.path}');
          handler.next(options);
        },
        onError: (DioException e, handler) async {
          final isAuthEndpoint =
              e.requestOptions.path.contains(ApiConstants.authEndpoint);

          if (e.response?.statusCode == 401 && !isAuthEndpoint) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              final newAccessToken = await tokenStorage.getAccessToken();
              final opts = e.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newAccessToken';

              try {
                final response = await dio.fetch(opts);
                return handler.resolve(response);
              } catch (retryError) {
                if (retryError is DioException) {
                  return handler.next(retryError);
                }
              }
            }
          }

          final appException = AppException.fromDioError(e);
          AppLogger.e(
              '❌ Error API [${e.response?.statusCode}]: ${appException.message}',
              e,
              e.stackTrace);
          handler.next(e);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      final username = await tokenStorage.getUsername() ?? AppConfig.username;
      final password = await tokenStorage.getPassword() ?? AppConfig.password;
      final clientId = await tokenStorage.getClientId() ?? AppConfig.clientId;
      final clientSecret =
          await tokenStorage.getClientSecret() ?? AppConfig.clientSecret;

      Map<String, dynamic> data;
      if (refreshToken != null && refreshToken.isNotEmpty) {
        data = {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': clientId,
          'client_secret': clientSecret,
        };
      } else if (username.isNotEmpty && password.isNotEmpty) {
        data = {
          'grant_type': 'password',
          'username': username,
          'password': password,
          'client_id': clientId,
          'client_secret': clientSecret,
        };
      } else {
        return false;
      }

      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      final response = await refreshDio.post(
        ApiConstants.authEndpoint,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final newAccessToken = response.data['access_token']?.toString();
        final newRefreshToken =
            response.data['refresh_token']?.toString() ?? refreshToken;

        if (newAccessToken != null) {
          await tokenStorage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken ?? '',
          );
          AppLogger.i('🔑 Token de acceso renovado exitosamente');
          return true;
        }
      }
    } catch (e) {
      AppLogger.e('⚠️ Error al intentar renovar el token: $e');
    }
    return false;
  }

  void _setupSSLValidation() {
    // Solo para plataformas IO (Android/iOS)
    if (!kIsWeb) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) {
            // En producción, solo deberíamos aceptar certificados válidos
            // Aquí se podría implementar SSL Pinning comparando el fingerprint
            // return cert.sha256 == 'mi_sha_256_esperado';

            final isValidHost = host == 'api-sandbox.factus.com.co';
            return isValidHost;
          };
          return client;
        },
      );
    }
  }
}
