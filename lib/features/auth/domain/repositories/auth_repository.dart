import '../../data/models/auth_model.dart';

abstract class AuthRepository {
  Future<AuthModel> login();
}
