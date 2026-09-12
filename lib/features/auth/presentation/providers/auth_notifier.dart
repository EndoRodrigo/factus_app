import 'package:flutter_riverpod/legacy.dart';

import '../../data/models/auth_model.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_providers.dart';

class AuthState {
  final bool isLoading;
  final AuthModel? auth;
  final String? error;

  const AuthState({this.isLoading = false, this.auth, this.error});

  AuthState copyWith({bool? isLoading, AuthModel? auth, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      auth: auth ?? this.auth,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthNotifier(this.repository) : super(const AuthState());

  Future<void> login() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final auth = await repository.login();

      state = state.copyWith(isLoading: false, auth: auth);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final repository = ref.watch(authRepositoryProvider);

  return AuthNotifier(repository);
});
