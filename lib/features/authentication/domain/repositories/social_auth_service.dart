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

  // Apple Sign In - Fixed version
  Future<UserCredential?> signInWithApple() async {
    if (!Platform.isIOS) {
      throw Exception('Apple Sign-In is only available on iOS');
    }

    try {
      dev.log('Starting Apple Sign-In...');

      // First check if Apple Sign-In is available
      if (!await SignInWithApple.isAvailable()) {
        throw Exception('Apple Sign-In is not available on this device');
      }

      // Generate nonce for security
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      dev.log('Generated nonce, requesting Apple ID credential...');

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
        // Add state parameter for additional security
        state: 'signin_${DateTime.now().millisecondsSinceEpoch}',
      );

      dev.log('Apple credential obtained successfully');
      dev.log('Identity Token exists: ${appleCredential.identityToken != null}');
      dev.log('Authorization Code exists: ${appleCredential.authorizationCode != null}');
      dev.log('User Identifier: ${appleCredential.userIdentifier}');

      // Validate that we have the required tokens
      if (appleCredential.identityToken == null) {
        throw Exception('Failed to get Apple ID token');
      }

      // Create Firebase credential from Apple credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        // Use authorization code as access token
        accessToken: appleCredential.authorizationCode,
      );

      dev.log('Created Firebase OAuth credential');

      // Sign in to Firebase with the credential
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);

      dev.log('Firebase Apple sign-in successful');
      dev.log('User UID: ${userCredential.user?.uid}');
      dev.log('User Email: ${userCredential.user?.email}');
      dev.log('Display Name: ${userCredential.user?.displayName}');

      // If this is the first time signing in and we have full name info
      if (appleCredential.givenName != null || appleCredential.familyName != null) {
        final displayName = '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim();
        if (displayName.isNotEmpty && userCredential.user?.displayName == null) {
          try {
            await userCredential.user?.updateDisplayName(displayName);
            dev.log('Updated display name to: $displayName');
          } catch (e) {
            dev.log('Failed to update display name: $e');
          }
        }
      }

      return userCredential;
    } on SignInWithAppleAuthorizationException catch (e) {
      dev.log('Apple Sign-In Authorization Error: ${e.code}');
      dev.log('Error message: ${e.message}');

      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          dev.log('User canceled Apple Sign-In');
          return null; // User canceled, return null instead of throwing
        case AuthorizationErrorCode.failed:
          throw Exception('Apple Sign-In failed');
        case AuthorizationErrorCode.invalidResponse:
          throw Exception('Invalid response from Apple Sign-In');
        case AuthorizationErrorCode.notHandled:
          throw Exception('Apple Sign-In request was not handled');
        case AuthorizationErrorCode.unknown:
          throw Exception('Unknown error occurred during Apple Sign-In');
        default:
          throw Exception('Apple Sign-In error: ${e.message}');
      }
    } on FirebaseAuthException catch (e) {
      dev.log('Firebase Auth Error during Apple Sign-In: ${e.code}');
      dev.log('Firebase Auth Error message: ${e.message}');

      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception('An account already exists with a different sign-in method');
        case 'invalid-credential':
          throw Exception('The Apple credential is invalid');
        case 'operation-not-allowed':
          throw Exception('Apple Sign-In is not enabled in Firebase');
        case 'user-disabled':
          throw Exception('This user account has been disabled');
        default:
          throw Exception('Firebase authentication failed: ${e.message}');
      }
    } catch (e, stackTrace) {
      dev.log('Unexpected Apple Sign-In Error: $e');
      dev.log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Facebook Sign In - Improved version
  Future<UserCredential?> signInWithFacebook() async {
    try {
      dev.log('Starting Facebook Sign-In...');

      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      dev.log('Facebook login result status: ${loginResult.status}');

      if (loginResult.status == LoginStatus.success) {
        dev.log('Facebook login successful');

        final accessToken = loginResult.accessToken;
        if (accessToken == null) {
          throw Exception('Failed to get Facebook access token');
        }

        dev.log('Facebook access token obtained');

        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(accessToken.tokenString);

        // Sign in with Firebase using the credential
        final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(facebookAuthCredential);

        dev.log('Firebase Facebook sign-in successful');
        dev.log('User UID: ${userCredential.user?.uid}');
        dev.log('User Email: ${userCredential.user?.email}');

        return userCredential;
      } else if (loginResult.status == LoginStatus.cancelled) {
        dev.log('Facebook login cancelled by user');
        return null; // User cancelled
      } else {
        dev.log('Facebook login failed: ${loginResult.message}');
        throw Exception('Facebook login failed: ${loginResult.message}');
      }
    } on FirebaseAuthException catch (e) {
      dev.log('Firebase Auth Error during Facebook Sign-In: ${e.code}');
      dev.log('Firebase Auth Error message: ${e.message}');

      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception('An account already exists with a different sign-in method');
        case 'invalid-credential':
          throw Exception('The Facebook credential is invalid');
        case 'operation-not-allowed':
          throw Exception('Facebook Sign-In is not enabled in Firebase');
        case 'user-disabled':
          throw Exception('This user account has been disabled');
        default:
          throw Exception('Firebase authentication failed: ${e.message}');
      }
    } catch (e, stackTrace) {
      dev.log('Facebook Sign-In Error: $e');
      dev.log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Google Sign In - Improved version
  Future<UserCredential?> signInWithGoogle() async {
    try {
      dev.log('Starting Google Sign-In...');

      // Sign out first to ensure clean state
      await _googleSignIn.signOut();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        dev.log('User canceled Google sign-in');
        return null; // User cancelled
      }

      dev.log('Google user signed in: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      dev.log('Google auth tokens obtained');
      dev.log('Access Token exists: ${googleAuth.accessToken != null}');
      dev.log('ID Token exists: ${googleAuth.idToken != null}');

      // Validate that we have the required tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to get Google authentication tokens');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google user credential
      final UserCredential userCredential =
      await _firebaseAuth.signInWithCredential(credential);

      dev.log('Firebase Google sign-in successful');
      dev.log('User UID: ${userCredential.user?.uid}');
      dev.log('User Email: ${userCredential.user?.email}');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      dev.log('Firebase Auth Error during Google Sign-In: ${e.code}');
      dev.log('Firebase Auth Error message: ${e.message}');

      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception('An account already exists with a different sign-in method');
        case 'invalid-credential':
          throw Exception('The Google credential is invalid');
        case 'operation-not-allowed':
          throw Exception('Google Sign-In is not enabled in Firebase');
        case 'user-disabled':
          throw Exception('This user account has been disabled');
        default:
          throw Exception('Firebase authentication failed: ${e.message}');
      }
    } catch (e, stackTrace) {
      dev.log('Google Sign-In Error: $e');
      dev.log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Sign Out - Improved version
  Future<void> signOut() async {
    try {
      dev.log('Starting sign out process...');

      // Sign out from all services
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        FacebookAuth.instance.logOut(),
      ]);

      dev.log('Sign out completed successfully');
    } catch (e) {
      dev.log('Sign out error: $e');
      // Don't rethrow - sign out should always succeed
    }
  }

  // Helper methods for Apple Sign-In
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