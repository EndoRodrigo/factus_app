import '../entities/auth.dart';

abstract class AuthRepository {
  Future<Auth> login({
    String? username,
    String? password,
    String? clientId,
    String? clientSecret,
  });
}
