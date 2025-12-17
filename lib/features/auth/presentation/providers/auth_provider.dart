import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';

// --- DI Providers ---

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);
final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    ref.watch(firebaseAuthProvider),
    ref.watch(googleSignInProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

// --- State ---
class AuthState extends Equatable {
  final UserEntity? user;
  final bool isLoading;
  final String? errorMessage;
  final bool obscurePassword; // UI state for password visibility

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.obscurePassword = true,
  });

  const AuthState.initial()
    : user = null,
      isLoading = false,
      errorMessage = null,
      obscurePassword = true;

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? errorMessage,
    bool? obscurePassword,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Allow clearing error by passing null
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, errorMessage, obscurePassword];
}

// --- Providers ---

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

final authStateChangesProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}, dependencies: [authRepositoryProvider]);

class AuthNotifier extends Notifier<AuthState> {
  // We can access repository via ref.read in methods if we want, or keep it in a variable.
  // However, Notifier has `ref` available.

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    Future.microtask(() => _checkCurrentUser());
    return const AuthState(isLoading: true);
  }

  Future<void> _checkCurrentUser() async {
    final result = await _repository.getCurrentUser();
    result.fold(
      (failure) => state = state.copyWith(user: null, isLoading: false),
      (user) => state = state.copyWith(user: user, isLoading: false),
    );
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repository.signInWithEmail(email, password);
    state = result.fold(
      (failure) =>
          state.copyWith(isLoading: false, errorMessage: failure.message),
      (user) => state.copyWith(isLoading: false, user: user),
    );
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repository.registerWithEmail(email, password);
    state = result.fold(
      (failure) =>
          state.copyWith(isLoading: false, errorMessage: failure.message),
      (user) => state.copyWith(isLoading: false, user: user),
    );
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repository.signInWithGoogle();
    state = result.fold(
      (failure) =>
          state.copyWith(isLoading: false, errorMessage: failure.message),
      (user) => state.copyWith(isLoading: false, user: user),
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await _repository.signOut();
    state = const AuthState.initial();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }
}
