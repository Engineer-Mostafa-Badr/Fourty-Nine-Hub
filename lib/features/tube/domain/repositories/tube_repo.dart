import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/add_favorite_tube_entity.dart';
import '../entities/get_all_tube_videos_entity.dart';
import '../entities/get_tube_video_commnets_entity.dart';
import '../usecases/add_favorite_tube_use_case.dart';
import '../usecases/create_comment_tube_video_use_case.dart';
import '../usecases/get_all_tube_videos_use_case.dart';
import '../usecases/get_related_tube_videos_use_case.dart';
import '../usecases/search_tube_use_case.dart';
import '../usecases/update_comment_tube_video_use_case.dart';


abstract class TubeRepository {

  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getAllTubeVideos({required GetAllTubeVideosParams params});
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getTubeFavoriteVideos({required GetAllTubeVideosParams params});
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> searchTubeVideo({required SearchTubeParams params});
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getRelatedTubeVideos({required GetRelatedTubeVideosParams params});

  // ✅ FIXED TYPE HERE
  Future<Either<Failure, TubeVideoCommentsEntity>> getTubeVideoComments({required GetRelatedTubeVideosParams params});

  Future<Either<Failure, AddFavoriteTubeEntity>> addFavoriteTube({required FavoriteTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> likeTubeVideo({required FavoriteTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> disLikeTubeVideo({required FavoriteTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> deleteTubeComment({required FavoriteTubeParams params});

  Future<Either<Failure, AddFavoriteTubeEntity>> removeFavoriteTube({required FavoriteTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> createCommentTube({required CreateCommentTubeParams params});
  Future<Either<Failure, AddFavoriteTubeEntity>> updateCommentTube({required UpdateCommentTubeParams params});


}
