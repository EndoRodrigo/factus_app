import 'package:dio/dio.dart';
import '../../../../core/exceptions/app_exception.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_config.dart';
import '../models/auth_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<AuthModel> login() async {
    try {
      final response = await dio.post(
        ApiConstants.authEndpoint,
        data: {
          'grant_type': 'password',
          'username': AppConfig.username,
          'password': AppConfig.password,
          'client_id': AppConfig.clientId,
          'client_secret': AppConfig.clientSecret,
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
