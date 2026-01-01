import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';
import '../models/auth/signup_request.dart';
import '../services/auth_service.dart';
import '../storage/auth_storage.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStorageProvider = Provider<AuthStorage>((ref) => AuthStorage());

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(authServiceProvider),
    ref.read(authStorageProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final AuthStorage _authStorage;

  AuthNotifier(this._authService, this._authStorage) : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await _authStorage.isLoggedIn();
    if (isLoggedIn) {
      final email = await _authStorage.getEmail();
      final organizationId = await _authStorage.getOrganizationId();
      state = AuthState.authenticated(
        email: email ?? '',
        organizationId: organizationId ?? '',
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.login(
        LoginRequest(email: email, password: password),
      );
      state = AuthState.authenticated(
        email: response.email,
        organizationId: response.organizationId,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signup(String organizationName, String email, String password, String name) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.signup(
        SignupRequest(
          organizationName: organizationName,
          email: email,
          password: password,
          name: name,
        ),
      );
      state = AuthState.authenticated(
        email: response.email,
        organizationId: response.organizationId,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState.initial();
  }
}

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final String? email;
  final String? organizationId;

  AuthState({
    required this.isAuthenticated,
    required this.isLoading,
    this.error,
    this.email,
    this.organizationId,
  });

  factory AuthState.initial() {
    return AuthState(
      isAuthenticated: false,
      isLoading: false,
    );
  }

  factory AuthState.authenticated({
    required String email,
    required String organizationId,
  }) {
    return AuthState(
      isAuthenticated: true,
      isLoading: false,
      email: email,
      organizationId: organizationId,
    );
  }

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    String? email,
    String? organizationId,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      email: email ?? this.email,
      organizationId: organizationId ?? this.organizationId,
    );
  }
}

