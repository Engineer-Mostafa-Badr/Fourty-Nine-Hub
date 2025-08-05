import 'dart:convert';
import 'dart:developer' as dev;
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
    serverClientId: '872417805780-auso8n3398jmm9l41ls8ttnjmloo3lmb.apps.googleusercontent.com',
  );

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Get ID Token
  Future<String?> getIdToken() async {
    final user = _firebaseAuth.currentUser;
    return await user?.getIdToken();
  }

  // Apple Sign In
  // Future<UserCredential?> signInWithApple() async {
  //   if (!Platform.isIOS) {
  //     throw Exception('Apple Sign-In is only available on iOS');
  //   }

  //   try {
  //     // Generate nonce for security
  //     final rawNonce = _generateNonce();
  //     final nonce = _sha256ofString(rawNonce);

  //     // Request credential for the currently signed in Apple account
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       nonce: nonce,
  //     );

  //     // Create an `OAuthCredential` from the credential returned by Apple
  //     final oauthCredential = OAuthProvider("apple.com").credential(
  //       idToken: appleCredential.identityToken,
  //       rawNonce: rawNonce,
  //     );

  //     // Sign in the user with Firebase
  //     final UserCredential userCredential =
  //         await _firebaseAuth.signInWithCredential(oauthCredential);

  //     return userCredential;
  //   } catch (e) {
  //     print('Apple Sign-In Error: $e');
  //     rethrow;
  //   }
  // }
  Future<UserCredential?> signInWithApple() async {
    if (!Platform.isIOS) {
      throw Exception('Apple Sign-In is only available on iOS');
    }

    try {
      dev.log('Starting Apple Sign-In...');
      
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

      dev.log('Apple credential obtained');

      // Create an `OAuthCredential` from the credential returned by Apple
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);

      dev.log('Firebase Apple sign-in successful: ${userCredential.user?.email}');
      return userCredential;
    } catch (e, stackTrace) {
      dev.log('Apple Sign-In Error: $e');
      dev.log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Facebook Sign In
  // Future<UserCredential?> signInWithFacebook() async {
  //   try {
  //     // Trigger the sign-in flow
  //     final LoginResult loginResult = await FacebookAuth.instance.login(
  //       permissions: ['email', 'public_profile'],
  //     );

  //     if (loginResult.status == LoginStatus.success) {
  //       // Create a credential from the access token
  //       final OAuthCredential facebookAuthCredential =
  //           FacebookAuthProvider.credential(
  //               loginResult.accessToken!.tokenString);

  //       // Sign in with Firebase using the credential
  //       final UserCredential userCredential =
  //           await _firebaseAuth.signInWithCredential(facebookAuthCredential);

  //       return userCredential;
  //     } else {
  //       throw Exception('Facebook login failed: ${loginResult.message}');
  //     }
  //   } catch (e) {
  //     print('Facebook Sign-In Error: $e');
  //     rethrow;
  //   }
  // }
  Future<UserCredential?> signInWithFacebook() async {
    try {
      dev.log('Starting Facebook Sign-In...');

      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      dev.log('Facebook login result: ${loginResult.status}');

      if (loginResult.status == LoginStatus.success) {
        dev.log('Facebook login successful');

        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
          loginResult.accessToken!.tokenString,
        );

        // Sign in with Firebase using the credential
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(facebookAuthCredential);

        dev.log('Firebase Facebook sign-in successful: ${userCredential.user?.email}');
        return userCredential;
      } else {
        dev.log('Facebook login failed: ${loginResult.message}');
        throw Exception('Facebook login failed: ${loginResult.message}');
      }
    } catch (e, stackTrace) {
      dev.log('Facebook Sign-In Error: $e');
      dev.log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Google Sign In
  // Future<UserCredential?> signInWithGoogle() async {
  //   try {
  //     // Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  //     if (googleUser == null) {
  //       throw Exception('Google sign-in was canceled by user');
  //     }

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // Sign in to Firebase with the Google user credential
  //     final UserCredential userCredential =
  //         await _firebaseAuth.signInWithCredential(credential);

  //     return userCredential;
  //   } catch (e) {
  //     print('Google Sign-In Error: $e');
  //     rethrow;
  //   }
  // }
  Future<UserCredential?> signInWithGoogle() async {
    try {
      dev.log('Starting Google Sign-In...');

      // Sign out first to ensure clean state
      await _googleSignIn.signOut();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        dev.log('User canceled Google sign-in');
        return null;
      }

      dev.log('Google user: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      dev.log('Google auth - accessToken: ${googleAuth.accessToken != null}');
      dev.log('Google auth - idToken: ${googleAuth.idToken != null}');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google user credential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      dev.log('Firebase sign-in successful: ${userCredential.user?.email}');
      return userCredential;
    } catch (e, stackTrace) {
      dev.log('Google Sign-In Error: $e');
      dev.log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Sign Out
  // Future<void> signOut() async {
  //   await Future.wait([
  //     _firebaseAuth.signOut(),
  //     _googleSignIn.signOut(),
  //     FacebookAuth.instance.logOut(),
  //   ]);
  // }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        FacebookAuth.instance.logOut(),
      ]);
      dev.log('Sign out successful');
    } catch (e) {
      dev.log('Sign out error: $e');
    }
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
  // String _generateNonce([int length = 32]) {
  //   const charset =
  //       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  //   final random = Random.secure();
  //   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
  //       .join();
  // }

  // String _sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
