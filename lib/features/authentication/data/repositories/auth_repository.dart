import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  UserModel? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;

    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
      emailVerified: user.emailVerified,
      providerId: user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : null,
      createdAt: user.metadata.creationTime,
      lastSignInAt: user.metadata.lastSignInTime,
    );
  }

  // Stream of auth state changes
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoURL: user.photoURL,
        phoneNumber: user.phoneNumber,
        emailVerified: user.emailVerified,
        providerId: user.providerData.isNotEmpty
            ? user.providerData.first.providerId
            : null,
        createdAt: user.metadata.creationTime,
        lastSignInAt: user.metadata.lastSignInTime,
      );
    });
  }

  // Email & Password Sign Up
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null && displayName != null) {
        await credential.user!.updateDisplayName(displayName);
      }

      return UserModel(
        id: credential.user!.uid,
        email: credential.user!.email ?? '',
        displayName: credential.user!.displayName,
        photoURL: credential.user!.photoURL,
        phoneNumber: credential.user!.phoneNumber,
        emailVerified: credential.user!.emailVerified,
        providerId: credential.user!.providerData.isNotEmpty
            ? credential.user!.providerData.first.providerId
            : null,
        createdAt: credential.user!.metadata.creationTime,
        lastSignInAt: credential.user!.metadata.lastSignInTime,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Email & Password Sign In
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return UserModel(
        id: credential.user!.uid,
        email: credential.user!.email ?? '',
        displayName: credential.user!.displayName,
        photoURL: credential.user!.photoURL,
        phoneNumber: credential.user!.phoneNumber,
        emailVerified: credential.user!.emailVerified,
        providerId: credential.user!.providerData.isNotEmpty
            ? credential.user!.providerData.first.providerId
            : null,
        createdAt: credential.user!.metadata.creationTime,
        lastSignInAt: credential.user!.metadata.lastSignInTime,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Google Sign In
  Future<UserModel> signInWithGoogle() async {
    try {
      // Check if Google Play Services are available (Android only)
      if (defaultTargetPlatform == TargetPlatform.android) {
        final isAvailable = await _googleSignIn.isSignedIn();
        // This will trigger the Google Play Services dialog if needed
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('تم إلغاء تسجيل الدخول بجوجل');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Check if we have the required tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('فشل في الحصول على بيانات المصادقة من جوجل');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('فشل في إنشاء حساب المستخدم');
      }

      return UserModel(
        id: userCredential.user!.uid,
        email: userCredential.user!.email ?? '',
        displayName: userCredential.user!.displayName,
        photoURL: userCredential.user!.photoURL,
        phoneNumber: userCredential.user!.phoneNumber,
        emailVerified: userCredential.user!.emailVerified,
        providerId: userCredential.user!.providerData.isNotEmpty
            ? userCredential.user!.providerData.first.providerId
            : null,
        createdAt: userCredential.user!.metadata.creationTime,
        lastSignInAt: userCredential.user!.metadata.lastSignInTime,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Apple Sign In
  Future<UserModel> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);

      // Update display name if available
      if (appleCredential.givenName != null ||
          appleCredential.familyName != null) {
        final displayName =
            '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                .trim();
        if (displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
        }
      }

      return UserModel(
        id: userCredential.user!.uid,
        email: userCredential.user!.email ?? '',
        displayName: userCredential.user!.displayName,
        photoURL: userCredential.user!.photoURL,
        phoneNumber: userCredential.user!.phoneNumber,
        emailVerified: userCredential.user!.emailVerified,
        providerId: userCredential.user!.providerData.isNotEmpty
            ? userCredential.user!.providerData.first.providerId
            : null,
        createdAt: userCredential.user!.metadata.creationTime,
        lastSignInAt: userCredential.user!.metadata.lastSignInTime,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Update Profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Delete Account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      await user.delete();
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth Exceptions
  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'لا يوجد مستخدم بهذا البريد الإلكتروني';
        case 'wrong-password':
          return 'كلمة المرور غير صحيحة';
        case 'email-already-in-use':
          return 'البريد الإلكتروني مستخدم بالفعل';
        case 'weak-password':
          return 'كلمة المرور ضعيفة جداً';
        case 'invalid-email':
          return 'البريد الإلكتروني غير صحيح';
        case 'user-disabled':
          return 'تم تعطيل هذا الحساب';
        case 'too-many-requests':
          return 'تم تجاوز الحد الأقصى للمحاولات، يرجى المحاولة لاحقاً';
        case 'operation-not-allowed':
          return 'هذه العملية غير مسموح بها';
        case 'network-request-failed':
          return 'فشل في الاتصال بالشبكة';
        case 'account-exists-with-different-credential':
          return 'يوجد حساب بنفس البريد الإلكتروني مع مزود خدمة مختلف';
        case 'invalid-credential':
          return 'بيانات الاعتماد غير صحيحة';
        case 'operation-not-allowed':
          return 'تسجيل الدخول بجوجل غير مفعل في إعدادات Firebase';
        case 'popup-closed-by-user':
          return 'تم إغلاق نافذة تسجيل الدخول';
        case 'popup-blocked':
          return 'تم حظر نافذة تسجيل الدخول من المتصفح';
        case 'cancelled-popup-request':
          return 'تم إلغاء طلب تسجيل الدخول';
        case 'network-request-failed':
          return 'فشل في الاتصال بالشبكة، تحقق من اتصالك بالإنترنت';
        default:
          return 'حدث خطأ غير متوقع: ${e.message}';
      }
    }
    
    // Handle Google Sign-In specific errors
    if (e.toString().contains('network_error')) {
      return 'فشل في الاتصال بالشبكة، تحقق من اتصالك بالإنترنت';
    }
    if (e.toString().contains('sign_in_canceled')) {
      return 'تم إلغاء تسجيل الدخول بجوجل';
    }
    if (e.toString().contains('sign_in_failed')) {
      return 'فشل في تسجيل الدخول بجوجل';
    }
    if (e.toString().contains('play_services_not_available')) {
      return 'خدمات Google Play غير متوفرة على هذا الجهاز';
    }
    if (e.toString().contains('developer_error')) {
      return 'خطأ في إعدادات المطور، تحقق من تكوين Google Sign-In';
    }
    
    return 'حدث خطأ غير متوقع: ${e.toString()}';
  }
}
