class AppConfig {
  static const String clientId = String.fromEnvironment(
    'FACTUS_CLIENT_ID',
  );

  static const String clientSecret = String.fromEnvironment(
    'FACTUS_CLIENT_SECRET',
  );

  static const String username = String.fromEnvironment(
    'FACTUS_USERNAME',
  );

  static const String password = String.fromEnvironment(
    'FACTUS_PASSWORD',
  );


}