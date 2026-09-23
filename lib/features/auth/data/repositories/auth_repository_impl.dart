import '../../../../core/network/token_storage.dart';
import '../../domain/entities/auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../mappers/auth_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl(this.remoteDataSource, this.tokenStorage);

  @override
  Future<Auth> login({
    String? username,
    String? password,
    String? clientId,
    String? clientSecret,
  }) async {
    final model = await remoteDataSource.login(
      username: username,
      password: password,
      clientId: clientId,
      clientSecret: clientSecret,
    );

    await tokenStorage.saveTokens(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
    );

    if (username != null && username.isNotEmpty && password != null && password.isNotEmpty) {
      await tokenStorage.saveCredentials(
        username: username,
        password: password,
        clientId: clientId,
        clientSecret: clientSecret,
      );
    }

    return AuthMapper.toEntity(model);
  }
}
