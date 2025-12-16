import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

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
  // Access setup needed for Stream, repository not directly exposed here via DI for Stream yet?
  // We can use GetIt to get Repository or creating a provider for Repository.
  // Ideally, create a repository provider.
  return getIt<AuthRepository>().authStateChanges;
}, dependencies: []);

class AuthNotifier extends Notifier<AuthState> {
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;
  late final GoogleSignInUseCase _googleSignInUseCase;
  late final SignOutUseCase _signOutUseCase;
  late final GetCurrentUserUseCase _getCurrentUserUseCase;

  @override
  AuthState build() {
    _loginUseCase = getIt<LoginUseCase>();
    _registerUseCase = getIt<RegisterUseCase>();
    _googleSignInUseCase = getIt<GoogleSignInUseCase>();
    _signOutUseCase = getIt<SignOutUseCase>();
    _getCurrentUserUseCase = getIt<GetCurrentUserUseCase>();

    _checkCurrentUser();
    return const AuthState.initial();
  }

  Future<void> _checkCurrentUser() async {
    final result = await _getCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) => state = state.copyWith(user: null),
      (user) => state = state.copyWith(user: user),
    );
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );
    state = result.fold(
      (failure) =>
          state.copyWith(isLoading: false, errorMessage: failure.message),
      (user) => state.copyWith(isLoading: false, user: user),
    );
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _registerUseCase(
      RegisterParams(email: email, password: password),
    );
    state = result.fold(
      (failure) =>
          state.copyWith(isLoading: false, errorMessage: failure.message),
      (user) => state.copyWith(isLoading: false, user: user),
    );
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _googleSignInUseCase(const NoParams());
    state = result.fold(
      (failure) =>
          state.copyWith(isLoading: false, errorMessage: failure.message),
      (user) => state.copyWith(isLoading: false, user: user),
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await _signOutUseCase(const NoParams());
    state = const AuthState.initial();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }
}
