import '../../domain/entities/auth.dart';
import '../models/auth_model.dart';

class AuthMapper {
  static Auth toEntity(AuthModel model) {
    return Auth(
      tokenType: model.tokenType,
      expiresIn: model.expiresIn,
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
    );
  }
}
