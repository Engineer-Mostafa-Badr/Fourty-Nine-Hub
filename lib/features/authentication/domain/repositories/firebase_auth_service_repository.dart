import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failure.dart';

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
