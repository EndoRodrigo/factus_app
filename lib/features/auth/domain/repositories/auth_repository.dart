import '../../data/models/auth_model.dart';

abstract class AuthRepository {
  Future<AuthModel> login({
    required String username,
    required String password,
    required String clientId,
    required String clientSecret,
  });
}
