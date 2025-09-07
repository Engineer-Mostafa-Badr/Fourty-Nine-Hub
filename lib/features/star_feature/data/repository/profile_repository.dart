import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/star_feature/domain/repository/profile_repository.dart';

import '../../domain/entity/profile_entity.dart';
import '../data_source/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProfileEntity>> getMyProfile() async {
    try {
      final result = await remoteDataSource.getMyProfile();
      return Right(result);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> getProfileById(
      String profileId) async {
    try {
      final result = await remoteDataSource.getProfileById(profileId);
      return Right(result);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateProfile(
      UpdateProfileParams params) async {
    try {
      final result = await remoteDataSource.updateProfile(params);
      return Right(result);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProfileEntity>>> searchProfiles(
      SearchProfileParams params) async {
    try {
      final result = await remoteDataSource.searchProfiles(params);
      return result;
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(UnknownFailure(e.toString()));
    }
  }
}
