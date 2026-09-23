import 'package:factus_app/core/network/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockSecureStorage;
  late TokenStorage tokenStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    tokenStorage = TokenStorage(storage: mockSecureStorage);
  });

  group('TokenStorage Tests', () {
    test('saveTokens should write access and refresh tokens to secure storage', () async {
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      await tokenStorage.saveTokens(
        accessToken: 'access_123',
        refreshToken: 'refresh_456',
      );

      verify(() => mockSecureStorage.write(key: 'access_token', value: 'access_123')).called(1);
      verify(() => mockSecureStorage.write(key: 'refresh_token', value: 'refresh_456')).called(1);
    });

    test('getAccessToken should read access_token from storage', () async {
      when(() => mockSecureStorage.read(key: 'access_token'))
          .thenAnswer((_) async => 'access_123');

      final result = await tokenStorage.getAccessToken();

      expect(result, equals('access_123'));
      verify(() => mockSecureStorage.read(key: 'access_token')).called(1);
    });

    test('saveCredentials should store username and password', () async {
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      await tokenStorage.saveCredentials(
        username: 'user@factus.com',
        password: 'password123',
      );

      verify(() => mockSecureStorage.write(key: 'user_username', value: 'user@factus.com')).called(1);
      verify(() => mockSecureStorage.write(key: 'user_password', value: 'password123')).called(1);
    });

    test('clearTokens should delete access and refresh tokens', () async {
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      await tokenStorage.clearTokens();

      verify(() => mockSecureStorage.delete(key: 'access_token')).called(1);
      verify(() => mockSecureStorage.delete(key: 'refresh_token')).called(1);
    });
  });
}
