import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AuthModel> login({
    required String username,
    required String password,
    required String clientId,
    required String clientSecret,
  }) {
    return remoteDataSource.login(
      username: username,
      password: password,
      clientId: clientId,
      clientSecret: clientSecret,
    );
  }
}