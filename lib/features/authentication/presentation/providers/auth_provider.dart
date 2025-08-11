import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated =>
      _status == AuthStatus.authenticated && _user != null;
  bool get isLoading => _status == AuthStatus.loading;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        _user = user;
        _status = AuthStatus.authenticated;
        _errorMessage = null;
      } else {
        _user = null;
        _status = AuthStatus.unauthenticated;
        _errorMessage = null;
      }
      notifyListeners();
    });
  }

  // Email & Password Sign Up
  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      _setLoading();
      await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Email & Password Sign In
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading();
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading();
      await _authRepository.signInWithGoogle();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Apple Sign In
  Future<bool> signInWithApple() async {
    try {
      _setLoading();
      await _authRepository.signInWithApple();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _setLoading();
      await _authRepository.signOut();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Reset Password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading();
      await _authRepository.resetPassword(email);
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Update Profile
  Future<bool> updateProfile({String? displayName, String? photoURL}) async {
    try {
      _setLoading();
      await _authRepository.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );

      // Update local user data
      if (_user != null) {
        _user = _user!.copyWith(
          displayName: displayName ?? _user!.displayName,
          photoURL: photoURL ?? _user!.photoURL,
        );
      }

      _status = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Delete Account
  Future<bool> deleteAccount() async {
    try {
      _setLoading();
      await _authRepository.deleteAccount();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Clear Error
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = _user != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // Set Loading State
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  // Set Error State
  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  // Get current user from repository
  UserModel? getCurrentUser() {
    return _authRepository.currentUser;
  }
}
