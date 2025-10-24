import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/tube/domain/entities/add_favorite_tube_entity.dart';
import 'package:fourtyninehub/features/tube/domain/entities/get_all_tube_videos_entity.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/add_favorite_tube_use_case.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/get_all_tube_videos_use_case.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/search_tube_use_case.dart';

import '../../domain/repositories/tube_repo.dart';

import '../datasource/tube_remote_datasource.dart';

class TubeRepoImpl implements TubeRepository {
  final TubeRemoteDataSource _remoteDataSource;
  TubeRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getAllTubeVideos({required GetAllTubeVideosParams params}) {
   return _remoteDataSource.getAllTubeVideos(params: params);
  }

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getTubeFavoriteVideos({required GetAllTubeVideosParams params}) {
    return _remoteDataSource.getTubeFavoriteVideos(params: params);
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> addFavoriteTube({required FavoriteTubeParams params}) {
    return _remoteDataSource.addFavoriteTube(params: params);
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> removeFavoriteTube({required FavoriteTubeParams params}) {
    return _remoteDataSource.removeFavoriteTube(params: params);
  }

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> searchTubeVideo({required SearchTubeParams params}) {
    return _remoteDataSource.searchTubeVideo(params: params);
  }







}
