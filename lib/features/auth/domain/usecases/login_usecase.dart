import '../entities/auth.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Auth> call({
    String? username,
    String? password,
    String? clientId,
    String? clientSecret,
  }) {
    return repository.login(
      username: username,
      password: password,
      clientId: clientId,
      clientSecret: clientSecret,
    );
  }
}
