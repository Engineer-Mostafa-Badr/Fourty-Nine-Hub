import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/error/failure.dart';

String _sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

abstract class FirebaseAuthServiceRepository {
  Future<Either<Failure, void>> deleteAccount();
  Future<Either<Failure, String?>> getIdToken();
  Future<Either<Failure, Map<String, dynamic>?>> getUserInfo();
  Future<Either<Failure, bool>> isSignedIn();
  Future<Either<Failure, String?>> refreshIdToken();
  Future<Either<Failure, void>> sendEmailVerification();
  Future<Either<Failure, UserCredential?>> signInWithFacebook();
  Future<Either<Failure, UserCredential?>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> updateProfile(
      {String? displayName, String? photoURL});
}

class SocialAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Get ID Token
  Future<String?> getIdToken() async {
    final user = _firebaseAuth.currentUser;
    return await user?.getIdToken();
  }

  // Apple Sign In
  Future<UserCredential?> signInWithApple() async {
    if (!Platform.isIOS) {
      throw Exception('Apple Sign-In is only available on iOS');
    }

    try {
      // Generate nonce for security
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      return userCredential;
    } catch (e) {
      print('Apple Sign-In Error: $e');
      rethrow;
    }
  }

  // Facebook Sign In
  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
                loginResult.accessToken!.tokenString);

        // Sign in with Firebase using the credential
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(facebookAuthCredential);

        return userCredential;
      } else {
        throw Exception('Facebook login failed: ${loginResult.message}');
      }
    } catch (e) {
      print('Facebook Sign-In Error: $e');
      rethrow;
    }
  }

  // Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in was canceled by user');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google user credential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      return userCredential;
    } catch (e) {
      print('Google Sign-In Error: $e');
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      FacebookAuth.instance.logOut(),
    ]);
  }

  // // Helper methods for Apple Sign-In
  // String _generateNonce([int length = 32]) {
  //   const charset =
  //       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  //   final random = Random.secure();
  //   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
  //       .join();
  // }

  // Helper methods for Apple Sign-In
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
