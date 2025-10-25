import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/tube/domain/entities/add_favorite_tube_entity.dart';
import 'package:fourtyninehub/features/tube/domain/entities/get_all_tube_videos_entity.dart';
import 'package:fourtyninehub/features/tube/domain/entities/get_tube_video_commnets_entity.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/add_favorite_tube_use_case.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/create_comment_tube_video_use_case.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/get_all_tube_videos_use_case.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/get_related_tube_videos_use_case.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/search_tube_use_case.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/update_comment_tube_video_use_case.dart';

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

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getRelatedTubeVideos({required GetRelatedTubeVideosParams params}) {
    return _remoteDataSource.getRelatedTubeVideos(params: params);
  }

  @override
  Future<Either<Failure, TubeVideoCommentsEntity>> getTubeVideoComments({required GetRelatedTubeVideosParams params}) {
    return _remoteDataSource.getTubeVideoComments(params: params);
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> createCommentTube({required CreateCommentTubeParams params}) {
    return _remoteDataSource.createCommentTube(params: params);
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> updateCommentTube({required UpdateCommentTubeParams params}) {
    return _remoteDataSource.updateCommentTube(params: params);
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> deleteTubeComment({required FavoriteTubeParams params}) {
    return _remoteDataSource.deleteTubeComment(params: params);
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> disLikeTubeVideo({required FavoriteTubeParams params}) {
    return _remoteDataSource.disLikeTubeVideo(params: params);
  }

  @override
  Future<Either<Failure, AddFavoriteTubeEntity>> likeTubeVideo({required FavoriteTubeParams params}) {
    return _remoteDataSource.likeTubeVideo(params: params);
  }







}
