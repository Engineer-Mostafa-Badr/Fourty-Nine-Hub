// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:logger/logger.dart';

// // Custom exception class for data source errors
// class AuthDataSourceException implements Exception {
//   final String message;
//   AuthDataSourceException(this.message);

//   @override
//   String toString() => 'AuthDataSourceException: $message';
// }

// abstract class FirebaseAuthServiceDataSource {
//   Stream<User?> get authStateChanges;
//   User? get currentUser;
//   Future<void> deleteAccount();
//   Future<String?> getIdToken();
//   Map<String, dynamic>? getUserInfo();
//   bool isSignedIn();
//   Future<String?> refreshIdToken();
//   Future<void> sendEmailVerification();
//   Future<UserCredential?> signInWithFacebook();
//   Future<UserCredential?> signInWithGoogle();
//   Future<void> signOut();
//   Future<void> updateProfile({String? displayName, String? photoURL});
// }

// // Helper widget for auth state management
// class AuthWrapper extends StatelessWidget {
//   final Widget signedInWidget;
//   final Widget signedOutWidget;

//   const AuthWrapper({
//     super.key,
//     required this.signedInWidget,
//     required this.signedOutWidget,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuthServiceDataSourceImpl().authStateChanges,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (snapshot.hasData) {
//           return signedInWidget;
//         } else {
//           return signedOutWidget;
//         }
//       },
//     );
//   }
// }

// class FirebaseAuthServiceDataSourceImpl implements FirebaseAuthServiceDataSource {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final logger = Logger();
//   FirebaseAuthServiceDataSourceImpl();

//   @override
//   Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

//   @override
//   User? get currentUser => _firebaseAuth.currentUser;

//   // Delete account
//   @override
//   Future<void> deleteAccount() async {
//     try {
//       final User? user = currentUser;
//       if (user != null) {
//         await user.delete();
//       }
//     } catch (e) {
//       logger.e('Delete Account Error: $e');
//       throw AuthDataSourceException('Delete account failed: ${e.toString()}');
//     }
//   }

//   // Get Firebase ID Token (for backend communication)
//   @override
//   Future<String?> getIdToken() async {
//     try {
//       final User? user = currentUser;
//       if (user != null) {
//         return await user.getIdToken();
//       }
//       return null;
//     } catch (e) {
//       logger.e('Get ID Token Error: $e');
//       return null;
//     }
//   }

//   // Get user profile info
//   @override
//   Map<String, dynamic>? getUserInfo() {
//     final User? user = currentUser;
//     if (user != null) {
//       return {
//         'uid': user.uid,
//         'email': user.email,
//         'displayName': user.displayName,
//         'photoURL': user.photoURL,
//         'isEmailVerified': user.emailVerified,
//         'phoneNumber': user.phoneNumber,
//         'creationTime': user.metadata.creationTime?.toIso8601String(),
//         'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
//       };
//     }
//     return null;
//   }

//   // Check if user is signed in
//   @override
//   bool isSignedIn() {
//     return currentUser != null;
//   }

//   // Refresh ID Token
//   @override
//   Future<String?> refreshIdToken() async {
//     try {
//       final User? user = currentUser;
//       if (user != null) {
//         return await user.getIdToken(true);
//       }
//       return null;
//     } catch (e) {
//       logger.e('Refresh ID Token Error: $e');
//       return null;
//     }
//   }

//   // Send email verification
//   @override
//   Future<void> sendEmailVerification() async {
//     try {
//       final User? user = currentUser;
//       if (user != null && !user.emailVerified) {
//         await user.sendEmailVerification();
//       }
//     } catch (e) {
//       logger.e('Send Email Verification Error: $e');
//       throw AuthDataSourceException(
//           'Send email verification failed: ${e.toString()}');
//     }
//   }

//   // Sign in with Facebook
//   @override
//   Future<UserCredential?> signInWithFacebook() async {
//     try {
//       // Trigger Facebook login
//       final LoginResult loginResult = await FacebookAuth.instance.login(
//         permissions: ['email', 'public_profile'],
//       );

//       if (loginResult.status == LoginStatus.success) {
//         // Get access token
//         final AccessToken accessToken = loginResult.accessToken!;

//         // Create Facebook credential
//         final OAuthCredential facebookAuthCredential =
//             FacebookAuthProvider.credential(accessToken.tokenString);

//         // Sign in to Firebase with Facebook credential
//         final UserCredential userCredential =
//             await _firebaseAuth.signInWithCredential(facebookAuthCredential);

//         return userCredential;
//       } else if (loginResult.status == LoginStatus.cancelled) {
//         // User cancelled login
//         return null;
//       } else {
//         throw AuthDataSourceException(
//             'Facebook login failed: ${loginResult.message}');
//       }
//     } catch (e) {
//       logger.e('Facebook Sign In Error: $e');
//       throw AuthDataSourceException('Facebook sign in failed: ${e.toString()}');
//     }
//   }

//   // Sign in with Google
//   @override
//   Future<UserCredential?> signInWithGoogle() async {
//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser == null) {
//         // User canceled the sign-in
//         return null;
//       }

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase with the Google credential
//       final UserCredential userCredential =
//           await _firebaseAuth.signInWithCredential(credential);

//       return userCredential;
//     } catch (e) {
//       logger.e('Google Sign In Error: $e');
//       throw AuthDataSourceException('Google sign in failed: ${e.toString()}');
//     }
//   }

//   // Sign out
//   @override
//   Future<void> signOut() async {
//     try {
//       // Sign out from Google
//       await _googleSignIn.signOut();

//       // Sign out from Facebook
//       await FacebookAuth.instance.logOut();

//       // Sign out from Firebase
//       await _firebaseAuth.signOut();
//     } catch (e) {
//       logger.e('Sign Out Error: $e');
//       throw AuthDataSourceException('Sign out failed: ${e.toString()}');
//     }
//   }

//   // Update user profile
//   @override
//   Future<void> updateProfile({String? displayName, String? photoURL}) async {
//     try {
//       final User? user = currentUser;
//       if (user != null) {
//         await user.updateDisplayName(displayName);
//         await user.updatePhotoURL(photoURL);
//         await user.reload();
//       }
//     } catch (e) {
//       logger.e('Update Profile Error: $e');
//       throw AuthDataSourceException('Update profile failed: ${e.toString()}');
//     }
//   }
// }
