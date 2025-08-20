// import 'dart:convert';
// import 'dart:developer' as dev;
// import 'dart:io';
// import 'dart:math';

// import 'package:crypto/crypto.dart';
// import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// import '../../../../core/error/failure.dart';

// String _sha256ofString(String input) {
//   final bytes = utf8.encode(input);
//   final digest = sha256.convert(bytes);
//   return digest.toString();
// }

// abstract class FirebaseAuthServiceRepository {
//   Future<Either<Failure, void>> deleteAccount();
//   Future<Either<Failure, String?>> getIdToken();
//   Future<Either<Failure, Map<String, dynamic>?>> getUserInfo();
//   Future<Either<Failure, bool>> isSignedIn();
//   Future<Either<Failure, String?>> refreshIdToken();
//   Future<Either<Failure, void>> sendEmailVerification();
//   Future<Either<Failure, UserCredential?>> signInWithFacebook();
//   Future<Either<Failure, UserCredential?>> signInWithGoogle();
//   Future<Either<Failure, void>> signOut();
//   Future<Either<Failure, void>> updateProfile(
//       {String? displayName, String? photoURL});
// }

// class SocialAuthService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: ['email', 'profile'],
//     serverClientId: '872417805780-auso8n3398jmm9l41ls8ttnjmloo3lmb.apps.googleusercontent.com',
//   );

//   // Get current user
//   User? get currentUser => _firebaseAuth.currentUser;

//   // Get ID Token
//   Future<String?> getIdToken() async {
//     final user = _firebaseAuth.currentUser;
//     return await user?.getIdToken();
//   }

//   // Apple Sign In
//   // Future<UserCredential?> signInWithApple() async {
//   //   if (!Platform.isIOS) {
//   //     throw Exception('Apple Sign-In is only available on iOS');
//   //   }

//   //   try {
//   //     // Generate nonce for security
//   //     final rawNonce = _generateNonce();
//   //     final nonce = _sha256ofString(rawNonce);

//   //     // Request credential for the currently signed in Apple account
//   //     final appleCredential = await SignInWithApple.getAppleIDCredential(
//   //       scopes: [
//   //         AppleIDAuthorizationScopes.email,
//   //         AppleIDAuthorizationScopes.fullName,
//   //       ],
//   //       nonce: nonce,
//   //     );

//   //     // Create an `OAuthCredential` from the credential returned by Apple
//   //     final oauthCredential = OAuthProvider("apple.com").credential(
//   //       idToken: appleCredential.identityToken,
//   //       rawNonce: rawNonce,
//   //     );

//   //     // Sign in the user with Firebase
//   //     final UserCredential userCredential =
//   //         await _firebaseAuth.signInWithCredential(oauthCredential);

//   //     return userCredential;
//   //   } catch (e) {
//   //     print('Apple Sign-In Error: $e');
//   //     rethrow;
//   //   }
//   // }
//   Future<UserCredential?> signInWithApple() async {
//     if (!Platform.isIOS) {
//       throw Exception('Apple Sign-In is only available on iOS');
//     }

//     try {
//       dev.log('Starting Apple Sign-In...');

//       // Generate nonce for security
//       final rawNonce = _generateNonce();
//       final nonce = _sha256ofString(rawNonce);

//       // Request credential for the currently signed in Apple account
//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//         nonce: nonce,
//       );

//       dev.log('Apple credential obtained');

//       // Create an `OAuthCredential` from the credential returned by Apple
//       final oauthCredential = OAuthProvider("apple.com").credential(
//         idToken: appleCredential.identityToken,
//         accessToken: appleCredential.authorizationCode,
//         rawNonce: rawNonce,
//       );

//       // Sign in the user with Firebase
//       final UserCredential userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);

//       dev.log('Firebase Apple sign-in successful: ${userCredential.user?.email}');
//       return userCredential;
//     } catch (e, stackTrace) {
//       dev.log('Apple Sign-In Error: $e');
//       dev.log('Stack trace: $stackTrace');
//       rethrow;
//     }
//   }

//   // Facebook Sign In
//   // Future<UserCredential?> signInWithFacebook() async {
//   //   try {
//   //     // Trigger the sign-in flow
//   //     final LoginResult loginResult = await FacebookAuth.instance.login(
//   //       permissions: ['email', 'public_profile'],
//   //     );

//   //     if (loginResult.status == LoginStatus.success) {
//   //       // Create a credential from the access token
//   //       final OAuthCredential facebookAuthCredential =
//   //           FacebookAuthProvider.credential(
//   //               loginResult.accessToken!.tokenString);

//   //       // Sign in with Firebase using the credential
//   //       final UserCredential userCredential =
//   //           await _firebaseAuth.signInWithCredential(facebookAuthCredential);

//   //       return userCredential;
//   //     } else {
//   //       throw Exception('Facebook login failed: ${loginResult.message}');
//   //     }
//   //   } catch (e) {
//   //     print('Facebook Sign-In Error: $e');
//   //     rethrow;
//   //   }
//   // }
//   Future<UserCredential?> signInWithFacebook() async {
//     try {
//       dev.log('Starting Facebook Sign-In...');

//       // Trigger the sign-in flow
//       final LoginResult loginResult = await FacebookAuth.instance.login(
//         permissions: ['email', 'public_profile'],
//       );

//       dev.log('Facebook login result: ${loginResult.status}');

//       if (loginResult.status == LoginStatus.success) {
//         dev.log('Facebook login successful');

//         // Create a credential from the access token
//         final OAuthCredential facebookAuthCredential =
//             FacebookAuthProvider.credential(
//           loginResult.accessToken!.tokenString,
//         );

//         // Sign in with Firebase using the credential
//         final UserCredential userCredential =
//             await _firebaseAuth.signInWithCredential(facebookAuthCredential);

//         dev.log('Firebase Facebook sign-in successful: ${userCredential.user?.email}');
//         return userCredential;
//       } else {
//         dev.log('Facebook login failed: ${loginResult.message}');
//         throw Exception('Facebook login failed: ${loginResult.message}');
//       }
//     } catch (e, stackTrace) {
//       dev.log('Facebook Sign-In Error: $e');
//       dev.log('Stack trace: $stackTrace');
//       rethrow;
//     }
//   }

//   // Google Sign In
//   // Future<UserCredential?> signInWithGoogle() async {
//   //   try {
//   //     // Trigger the authentication flow
//   //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//   //     if (googleUser == null) {
//   //       throw Exception('Google sign-in was canceled by user');
//   //     }

//   //     // Obtain the auth details from the request
//   //     final GoogleSignInAuthentication googleAuth =
//   //         await googleUser.authentication;

//   //     // Create a new credential
//   //     final credential = GoogleAuthProvider.credential(
//   //       accessToken: googleAuth.accessToken,
//   //       idToken: googleAuth.idToken,
//   //     );

//   //     // Sign in to Firebase with the Google user credential
//   //     final UserCredential userCredential =
//   //         await _firebaseAuth.signInWithCredential(credential);

//   //     return userCredential;
//   //   } catch (e) {
//   //     print('Google Sign-In Error: $e');
//   //     rethrow;
//   //   }
//   // }
//   Future<UserCredential?> signInWithGoogle() async {
//     try {
//       dev.log('Starting Google Sign-In...');

//       // Sign out first to ensure clean state
//       await _googleSignIn.signOut();

//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser == null) {
//         dev.log('User canceled Google sign-in');
//         return null;
//       }

//       dev.log('Google user: ${googleUser.email}');

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       dev.log('Google auth - accessToken: ${googleAuth.accessToken != null}');
//       dev.log('Google auth - idToken: ${googleAuth.idToken != null}');

//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase with the Google user credential
//       final UserCredential userCredential =
//           await _firebaseAuth.signInWithCredential(credential);

//       dev.log('Firebase sign-in successful: ${userCredential.user?.email}');
//       return userCredential;
//     } catch (e, stackTrace) {
//       dev.log('Google Sign-In Error: $e');
//       dev.log('Stack trace: $stackTrace');
//       rethrow;
//     }
//   }

//   // Sign Out
//   // Future<void> signOut() async {
//   //   await Future.wait([
//   //     _firebaseAuth.signOut(),
//   //     _googleSignIn.signOut(),
//   //     FacebookAuth.instance.logOut(),
//   //   ]);
//   // }

//   Future<void> signOut() async {
//     try {
//       await Future.wait([
//         _firebaseAuth.signOut(),
//         _googleSignIn.signOut(),
//         FacebookAuth.instance.logOut(),
//       ]);
//       dev.log('Sign out successful');
//     } catch (e) {
//       dev.log('Sign out error: $e');
//     }
//   }

//   // // Helper methods for Apple Sign-In
//   // String _generateNonce([int length = 32]) {
//   //   const charset =
//   //       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//   //   final random = Random.secure();
//   //   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
//   //       .join();
//   // }

//   // Helper methods for Apple Sign-In
//   // String _generateNonce([int length = 32]) {
//   //   const charset =
//   //       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//   //   final random = Random.secure();
//   //   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
//   //       .join();
//   // }

//   // String _sha256ofString(String input) {
//   //   final bytes = utf8.encode(input);
//   //   final digest = sha256.convert(bytes);
//   //   return digest.toString();
//   // }

//   String _generateNonce([int length = 32]) {
//     const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//     final random = Random.secure();
//     return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
//   }

//   String _sha256ofString(String input) {
//     final bytes = utf8.encode(input);
//     final digest = sha256.convert(bytes);
//     return digest.toString();
//   }
// }

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
  Future<Either<Failure, UserCredential?>> signInWithApple();
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
    // هذا يجب أن يطابق CLIENT_ID في GoogleService-Info.plist
    serverClientId:
        '361206050719-6go2s7r10d1pckpo715rmc21jne7fddo.apps.googleusercontent.com',
        
  );

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Get ID Token
  Future<String?> getIdToken() async {
    final user = _firebaseAuth.currentUser;
    return await user?.getIdToken();
  }

  // Apple Sign In - Fixed to use the simple working method
  Future<UserCredential?> signInWithApple() async {
    if (!Platform.isIOS) {
      throw Exception('Apple Sign-In is only available on iOS');
    }

    try {
      dev.log('Starting Apple Sign-In...');

      // Use the simple Firebase method that works
      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('name');

      final UserCredential userCredential =
          await _firebaseAuth.signInWithProvider(appleProvider);

      dev.log('Firebase Apple sign-in successful');
      dev.log('User UID: ${userCredential.user?.uid}');
      dev.log('User Email: ${userCredential.user?.email}');
      dev.log('Display Name: ${userCredential.user?.displayName}');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      dev.log('Firebase Auth Error during Apple Sign-In: ${e.code}');
      dev.log('Firebase Auth Error message: ${e.message}');

      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception(
              'An account already exists with a different sign-in method');
        case 'invalid-credential':
          throw Exception('The Apple credential is invalid');
        case 'operation-not-allowed':
          throw Exception('Apple Sign-In is not enabled in Firebase');
        case 'user-disabled':
          throw Exception('This user account has been disabled');
        case 'cancelled':
        case 'user-cancelled':
          dev.log('User cancelled Apple Sign-In');
          return null; // User cancelled, return null
        default:
          throw Exception('Firebase authentication failed: ${e.message}');
      }
    } catch (e, stackTrace) {
      dev.log('Unexpected Apple Sign-In Error: $e');
      dev.log('Stack trace: $stackTrace');

      // Handle user cancellation gracefully
      if (e.toString().contains('cancelled') ||
          e.toString().contains('canceled')) {
        dev.log('User cancelled Apple Sign-In');
        return null;
      }

      rethrow;
    }
  }

  // Facebook Sign In - Improved with better token handling
  Future<UserCredential?> signInWithFacebook() async {
    try {
      dev.log('Starting Facebook Sign-In...');

      // For better security, generate nonce for limited login
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        nonce: nonce, // Add nonce for security
      );

      dev.log('Facebook login result status: ${loginResult.status}');

      if (loginResult.status == LoginStatus.success) {
        dev.log('Facebook login successful');

        final accessToken = loginResult.accessToken;
        if (accessToken == null) {
          throw Exception('Failed to get Facebook access token');
        }

        dev.log('Facebook access token obtained');

        OAuthCredential facebookAuthCredential;

        // Handle different token types on iOS
        if (Platform.isIOS) {
          switch (accessToken.type) {
            case AccessTokenType.classic:
              final token = accessToken as ClassicToken;
              facebookAuthCredential = FacebookAuthProvider.credential(
                token.authenticationToken ?? token.tokenString,
              );
              break;
            case AccessTokenType.limited:
              final token = accessToken as LimitedToken;
              facebookAuthCredential = OAuthCredential(
                providerId: 'facebook.com',
                signInMethod: 'oauth',
                idToken: token.tokenString,
                rawNonce: rawNonce,
              );
              break;
            default:
              facebookAuthCredential = FacebookAuthProvider.credential(
                accessToken.tokenString,
              );
          }
        } else {
          // Android - use standard approach
          facebookAuthCredential = FacebookAuthProvider.credential(
            accessToken.tokenString,
          );
        }

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
          throw Exception(
              'An account already exists with a different sign-in method');
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

  // Google Sign In - Already working well, minor improvements
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
          throw Exception(
              'An account already exists with a different sign-in method');
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

  // Sign Out - Works well, keeping as is
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

  // Check if user is signed in
  bool isSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  // Get user info as Map
  Map<String, dynamic>? getUserInfo() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'emailVerified': user.emailVerified,
    };
  }

  // Helper methods
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
