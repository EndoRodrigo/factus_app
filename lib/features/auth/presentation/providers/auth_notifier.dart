import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../domain/entities/auth.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_providers.dart';

class AuthState {
  final bool isLoading;
  final Auth? auth;
  final String? error;

  const AuthState({this.isLoading = false, this.auth, this.error});

  AuthState copyWith({bool? isLoading, Auth? auth, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      auth: auth ?? this.auth,
      error: error,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late final LoginUseCase _loginUseCase;

  @override
  AuthState build() {
    _loginUseCase = ref.watch(loginUseCaseProvider);
    return const AuthState();
  }

  Future<void> login({
    String? username,
    String? password,
    String? clientId,
    String? clientSecret,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final auth = await _loginUseCase(
        username: username,
        password: password,
        clientId: clientId,
        clientSecret: clientSecret,
      );
      state = state.copyWith(isLoading: false, auth: auth);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : e.toString(),
      );
    }
  }

  Future<void> logout() async {
    final tokenStorage = ref.read(tokenStorageProvider);
    await tokenStorage.clearTokens();
    state = const AuthState();
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
