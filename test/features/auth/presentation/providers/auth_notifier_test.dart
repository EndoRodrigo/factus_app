import 'package:factus_app/core/exceptions/app_exception.dart';
import 'package:factus_app/core/network/token_storage.dart';
import 'package:factus_app/features/auth/domain/entities/auth.dart';
import 'package:factus_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:factus_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:factus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockTokenStorage mockTokenStorage;
  late ProviderContainer container;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockTokenStorage = MockTokenStorage();

    container = ProviderContainer(
      overrides: [
        loginUseCaseProvider.overrideWithValue(mockLoginUseCase),
        tokenStorageProvider.overrideWithValue(mockTokenStorage),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthNotifier Tests', () {
    const tAuth = Auth(
      accessToken: 'access_123',
      refreshToken: 'refresh_123',
      tokenType: 'Bearer',
      expiresIn: 3600,
    );

    test('initial state should be idle with null auth and error', () {
      final state = container.read(authNotifierProvider);

      expect(state.isLoading, isFalse);
      expect(state.auth, isNull);
      expect(state.error, isNull);
    });

    test('login success should update state with Auth entity', () async {
      when(() => mockLoginUseCase(
            username: 'user@factus.com',
            password: 'password123',
          )).thenAnswer((_) async => tAuth);

      final notifier = container.read(authNotifierProvider.notifier);

      await notifier.login(
        username: 'user@factus.com',
        password: 'password123',
      );

      final state = container.read(authNotifierProvider);

      expect(state.isLoading, isFalse);
      expect(state.auth, equals(tAuth));
      expect(state.error, isNull);
    });

    test('login failure should update state with error message', () async {
      when(() => mockLoginUseCase(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenThrow(AppException(message: 'Credenciales inválidas'));

      final notifier = container.read(authNotifierProvider.notifier);

      await notifier.login(
        username: 'wrong@factus.com',
        password: 'wrong_password',
      );

      final state = container.read(authNotifierProvider);

      expect(state.isLoading, isFalse);
      expect(state.auth, isNull);
      expect(state.error, equals('Credenciales inválidas'));
    });
  });
}
