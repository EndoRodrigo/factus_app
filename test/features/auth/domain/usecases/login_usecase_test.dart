import 'package:factus_app/features/auth/domain/entities/auth.dart';
import 'package:factus_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:factus_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase Tests', () {
    const tAuth = Auth(
      accessToken: 'token_123',
      refreshToken: 'refresh_123',
      tokenType: 'Bearer',
      expiresIn: 3600,
    );

    test('should call repository.login with provided credentials and return Auth entity', () async {
      when(() => mockRepository.login(
            username: 'user@factus.com',
            password: 'secret_password',
          )).thenAnswer((_) async => tAuth);

      final result = await loginUseCase(
        username: 'user@factus.com',
        password: 'secret_password',
      );

      expect(result, equals(tAuth));
      verify(() => mockRepository.login(
            username: 'user@factus.com',
            password: 'secret_password',
          )).called(1);
    });
  });
}
