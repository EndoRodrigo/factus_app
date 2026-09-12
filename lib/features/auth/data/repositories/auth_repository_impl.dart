import '../../../../core/network/token_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl(
      this.remoteDataSource,
      this.tokenStorage,
      );

  @override
  Future<AuthModel> login() async {
    final auth = await remoteDataSource.login();

    await tokenStorage.saveTokens(
      accessToken: auth.accessToken,
      refreshToken: auth.refreshToken,
    );

    return auth;
  }
}