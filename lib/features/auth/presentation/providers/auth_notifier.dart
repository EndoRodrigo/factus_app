import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../domain/entities/auth.dart';
import '../../domain/repositories/auth_repository.dart';
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
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    return const AuthState();
  }

  Future<void> login() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final auth = await _repository.login();
      state = state.copyWith(isLoading: false, auth: auth);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : e.toString(),
      );
    }
  }

  void logout() {
    state = const AuthState();
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
