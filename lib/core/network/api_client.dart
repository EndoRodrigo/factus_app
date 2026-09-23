import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
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
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await tokenStorage.getAccessToken();
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          AppLogger.i('📡 Petición: [${options.method}] ${options.path}');
          handler.next(options);
        },
        onError: (DioException e, handler) {
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
