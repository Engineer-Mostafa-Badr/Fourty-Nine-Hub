import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/comment_model.dart';
import '../../data/model/tube_video_models.dart';
import '../../data/model/active_category_model.dart';
import '../entity/banner_talent_entity.dart';
import '../entity/star_entity.dart';
import '../entity/star_winner_entity.dart';
import '../use_case/comment_use_cases.dart';
import '../use_case/fetch_all_star_use_case.dart';
import '../use_case/upload_my_star_use_case.dart';

abstract class StarRepository {
  // Existing methods
  Future<Either<Failure, List<StarEntity>>> fetchAllStar(
      StarPaginationParams params);
  Future<Either<Failure, List<StarWinnerEntity>>> fetchWinnerStar(
      StarPaginationParams params);
  Future<Either<Failure, List<StarEntity>>> fetchMyStar();
  Future<Either<Failure, BannerTalentEntity>> fetchBanner();
  Future<Either<Failure, List<TubeVideoModel>>> searchTubeVideos(String query);
  Future<Either<Failure, bool>> uploadMyStar(StarParams params);
  Future<Either<Failure, bool>> deleteMyStar({required String id});
  Future<Either<Failure, String>> addVideoToFavorite(String videoId);
  Future<Either<Failure, String>> removeVideoFromFavorite(String videoId);
  Future<Either<Failure, List<TubeVideoModel>>> getFavoriteVideos();

  // Watch Later methods
  Future<Either<Failure, String>> addVideoToWatchLater(String videoId);
  Future<Either<Failure, String>> removeVideoFromWatchLater(String videoId);
  Future<Either<Failure, List<TubeVideoModel>>> getWatchLaterVideos();

  // New Tube Video methods

  Future<Either<Failure, TubeVideoListResponse>> fetchAllTubeVideos(
      StarPaginationParams params);
  Future<Either<Failure, TubeVideoListResponse>> fetchMyTubeVideos(
      StarPaginationParams params);
  Future<Either<Failure, StarEntity>> fetchTubeVideoDetails(
      String videoId); // Todo: Get video by ID
  Future<Either<Failure, bool>> likeTubeVideo(String videoId);
  Future<Either<Failure, bool>> dislikeTubeVideo(String videoId);
  Future<Either<Failure, bool>> incrementTubeVideoView(String videoId);
  //Todo: Delete End points
  Future<Either<Failure, bool>> deleteTubeVideo(String videoId);

  // New Comment methods
  Future<Either<Failure, String>> createComment(CreateCommentParams params);
  Future<Either<Failure, CommentsListResponse>> getVideoComments(
      GetCommentsParams params);
  Future<Either<Failure, String>> updateComment(UpdateCommentParams params);
  Future<Either<Failure, String>> deleteComment(String commentId);
  Future<Either<Failure, String>> likeComment(String commentId);
  Future<Either<Failure, String>> dislikeComment(String commentId);

  // Get active categories
  Future<Either<Failure, ActiveCategoryResponse>> getActiveCategories();
}
