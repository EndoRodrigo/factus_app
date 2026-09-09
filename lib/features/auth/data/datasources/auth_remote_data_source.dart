import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/auth_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<AuthModel> login({
    required String username,
    required String password,
    required String clientId,
    required String clientSecret,
  }) async {
    final response = await dio.post(
      ApiConstants.authEndpoint,
      data: {
        'grant_type': 'password',
        'username': username,
        'password': password,
        'client_id': clientId,
        'client_secret': clientSecret,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    return AuthModel.fromJson(response.data);
  }
}