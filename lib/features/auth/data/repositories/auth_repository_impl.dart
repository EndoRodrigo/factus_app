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
  Future<Auth> login() async {
    final model = await remoteDataSource.login();

    await tokenStorage.saveTokens(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
    );

    return AuthMapper.toEntity(model);
  }
}
