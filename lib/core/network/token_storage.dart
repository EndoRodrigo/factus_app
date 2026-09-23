import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _usernameKey = 'user_username';
  static const _passwordKey = 'user_password';
  static const _clientIdKey = 'client_id';
  static const _clientSecretKey = 'client_secret';

  final FlutterSecureStorage storage;

  const TokenStorage({this.storage = const FlutterSecureStorage()});

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await storage.write(key: _accessTokenKey, value: accessToken);
    await storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return storage.read(key: _refreshTokenKey);
  }

  Future<void> saveCredentials({
    required String username,
    required String password,
    String? clientId,
    String? clientSecret,
  }) async {
    await storage.write(key: _usernameKey, value: username);
    await storage.write(key: _passwordKey, value: password);
    if (clientId != null && clientId.isNotEmpty) {
      await storage.write(key: _clientIdKey, value: clientId);
    }
    if (clientSecret != null && clientSecret.isNotEmpty) {
      await storage.write(key: _clientSecretKey, value: clientSecret);
    }
  }

  Future<String?> getUsername() async {
    return storage.read(key: _usernameKey);
  }

  Future<String?> getPassword() async {
    return storage.read(key: _passwordKey);
  }

  Future<String?> getClientId() async {
    return storage.read(key: _clientIdKey);
  }

  Future<String?> getClientSecret() async {
    return storage.read(key: _clientSecretKey);
  }

  Future<void> clearTokens() async {
    await storage.delete(key: _accessTokenKey);
    await storage.delete(key: _refreshTokenKey);
  }

  Future<void> clearCredentials() async {
    await storage.delete(key: _usernameKey);
    await storage.delete(key: _passwordKey);
    await storage.delete(key: _clientIdKey);
    await storage.delete(key: _clientSecretKey);
  }

  Future<void> clearAll() async {
    await clearTokens();
    await clearCredentials();
  }
}
