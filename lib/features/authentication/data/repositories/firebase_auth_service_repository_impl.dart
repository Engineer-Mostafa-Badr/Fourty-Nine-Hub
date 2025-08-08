// import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fourtyninehub/core/error/failure.dart';

// import '../../domain/repositories/firebase_auth_service_repository.dart';
// import '../data_sources/remote_data_source/firebase_auth_service.dart';

// class FirebaseAuthServiceRepositoryImpl
//     implements FirebaseAuthServiceRepository {
//   final FirebaseAuthServiceDataSource remoteDataSource;

//   FirebaseAuthServiceRepositoryImpl({required this.remoteDataSource});

//   @override
//   Future<Either<Failure, void>> deleteAccount() async {
//     try {
//       await remoteDataSource.deleteAccount();
//       return Right(unit);
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, String?>> getIdToken() async {
//     try {
//       return Right(await remoteDataSource.getIdToken());
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, Map<String, dynamic>?>> getUserInfo() async {
//     try {
//       return Right(remoteDataSource.getUserInfo());
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, bool>> isSignedIn() async {
//     try {
//       return Right(remoteDataSource.isSignedIn());
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, String?>> refreshIdToken() async {
//     try {
//       return Right(await remoteDataSource.refreshIdToken());
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> sendEmailVerification() async {
//     try {
//       await remoteDataSource.sendEmailVerification();
//       return Right(unit);
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, UserCredential?>> signInWithFacebook() async {
//     try {
//       return Right(await remoteDataSource.signInWithFacebook());
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, UserCredential?>> signInWithGoogle() async {
//     try {
//       return Right(await remoteDataSource.signInWithGoogle());
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> signOut() async {
//     try {
//       await remoteDataSource.signOut();
//       return Right(unit);
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> updateProfile(
//       {String? displayName, String? photoURL}) async {
//     try {
//       return Right(await remoteDataSource.updateProfile(
//           displayName: displayName, photoURL: photoURL));
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }
// }
