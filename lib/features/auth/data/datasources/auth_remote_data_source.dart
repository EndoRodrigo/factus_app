import 'package:dio/dio.dart';
import '../../../../core/exceptions/app_exception.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_config.dart';
import '../models/auth_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<AuthModel> login({
    String? username,
    String? password,
    String? clientId,
    String? clientSecret,
  }) async {
    try {
      final effectiveUsername = (username != null && username.isNotEmpty)
          ? username
          : AppConfig.username;
      final effectivePassword = (password != null && password.isNotEmpty)
          ? password
          : AppConfig.password;
      final effectiveClientId = (clientId != null && clientId.isNotEmpty)
          ? clientId
          : AppConfig.clientId;
      final effectiveClientSecret =
          (clientSecret != null && clientSecret.isNotEmpty)
              ? clientSecret
              : AppConfig.clientSecret;

      final response = await dio.post(
        ApiConstants.authEndpoint,
        data: {
          'grant_type': 'password',
          'username': effectiveUsername,
          'password': effectivePassword,
          'client_id': effectiveClientId,
          'client_secret': effectiveClientSecret,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
