import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaty/features/authentication/data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthState.initial()) {
    _initializeAuth();
  }

  void _initializeAuth() {
    _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  // Email & Password Sign Up
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      emit(const AuthState.loading());
      await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  // Email & Password Sign In
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      emit(const AuthState.loading());
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    try {
      emit(const AuthState.loading());
      await _authRepository.signInWithGoogle();
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  // Apple Sign In
  Future<void> signInWithApple() async {
    try {
      emit(const AuthState.loading());
      await _authRepository.signInWithApple();
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      emit(const AuthState.loading());
      await _authRepository.signOut();
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      emit(const AuthState.loading());
      await _authRepository.resetPassword(email);
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  // Update Profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      emit(const AuthState.loading());
      await _authRepository.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  // Delete Account
  Future<void> deleteAccount() async {
    try {
      emit(const AuthState.loading());
      await _authRepository.deleteAccount();
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  // Clear Error
  void clearError() {
    final currentState = state;
    if (currentState is Error) {
      emit(const AuthState.unauthenticated());
    }
  }

  // Get current user from repository
  UserModel? getCurrentUser() {
    return _authRepository.currentUser;
  }
}
