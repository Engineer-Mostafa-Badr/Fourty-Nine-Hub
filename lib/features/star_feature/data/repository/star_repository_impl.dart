import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/use_case/comment_use_cases.dart';
import '../data_source/star_remote_data_source.dart';
import '../../domain/entity/banner_talent_entity.dart';
import '../../domain/entity/star_entity.dart';
import '../../domain/entity/star_winner_entity.dart';
import '../../domain/repository/star_repository.dart';
import '../../domain/use_case/fetch_all_star_use_case.dart';
import '../../domain/use_case/upload_my_star_use_case.dart';
import '../model/comment_model.dart';
import '../model/tube_video_models.dart';

class StarRepositoryImpl extends StarRepository {
  final StarRemoteDataSource _remoteDataSource;

  StarRepositoryImpl(this._remoteDataSource);

  // Existing implementations remain the same
  @override
  Future<Either<Failure, List<StarEntity>>> fetchAllStar(
      StarPaginationParams params) {
    return _remoteDataSource.fetchAllStar(params);
  }

  @override
  Future<Either<Failure, List<TubeVideoModel>>> searchTubeVideos(String query) {
    return _remoteDataSource.searchTubeVideos(query);
  }

  @override
  Future<Either<Failure, String>> addVideoToFavorite(String videoId) {
    return _remoteDataSource.addVideoToFavorite(videoId);
  }

  @override
  Future<Either<Failure, String>> removeVideoFromFavorite(String videoId) {
    return _remoteDataSource.removeVideoFromFavorite(videoId);
  }

  @override
  Future<Either<Failure, List<TubeVideoModel>>> getFavoriteVideos() {
    return _remoteDataSource.getFavoriteVideos();
  }

  @override
  Future<Either<Failure, List<StarEntity>>> fetchMyStar() {
    return _remoteDataSource.fetchMyStar();
  }

  @override
  Future<Either<Failure, bool>> uploadMyStar(StarParams params) {
    return _remoteDataSource.uploadMyStar(params);
  }

  @override
  Future<Either<Failure, bool>> deleteMyStar({required String id}) {
    return _remoteDataSource.deleteMyStar(id: id);
  }

  @override
  Future<Either<Failure, List<StarWinnerEntity>>> fetchWinnerStar(
      StarPaginationParams params) {
    return _remoteDataSource.fetchWinnerStar(params);
  }

  @override
  Future<Either<Failure, BannerTalentEntity>> fetchBanner() {
    return _remoteDataSource.fetchBanner();
  }

  // NEW TUBE VIDEO IMPLEMENTATIONS
  @override
  Future<Either<Failure, TubeVideoListResponse>> fetchAllTubeVideos(
      StarPaginationParams params) {
    return _remoteDataSource.fetchAllTubeVideos(params);
  }

  @override
  Future<Either<Failure, TubeVideoListResponse>> fetchMyTubeVideos(
      StarPaginationParams params) {
    return _remoteDataSource.fetchMyTubeVideos(params);
  }

  @override
  Future<Either<Failure, StarEntity>> fetchTubeVideoDetails(String videoId) {
    return _remoteDataSource.fetchTubeVideoDetails(videoId);
  }

  @override
  Future<Either<Failure, bool>> likeTubeVideo(String videoId) {
    return _remoteDataSource.likeTubeVideo(videoId);
  }

  @override
  Future<Either<Failure, bool>> dislikeTubeVideo(String videoId) {
    return _remoteDataSource.dislikeTubeVideo(videoId);
  }

  @override
  Future<Either<Failure, bool>> incrementTubeVideoView(String videoId) {
    return _remoteDataSource.incrementTubeVideoView(videoId);
  }

  @override
  Future<Either<Failure, bool>> deleteTubeVideo(String videoId) {
    return _remoteDataSource.deleteTubeVideo(videoId);
  }

  // NEW COMMENT IMPLEMENTATIONS
  @override
  Future<Either<Failure, String>> createComment(CreateCommentParams params) {
    return _remoteDataSource.createComment(params);
  }

  @override
  Future<Either<Failure, CommentsListResponse>> getVideoComments(
      GetCommentsParams params) {
    return _remoteDataSource.getVideoComments(params);
  }

  @override
  Future<Either<Failure, String>> updateComment(UpdateCommentParams params) {
    return _remoteDataSource.updateComment(params);
  }

  @override
  Future<Either<Failure, String>> deleteComment(String commentId) {
    return _remoteDataSource.deleteComment(commentId);
  }

  @override
  Future<Either<Failure, String>> likeComment(String commentId) {
    return _remoteDataSource.likeComment(commentId);
  }

  @override
  Future<Either<Failure, String>> dislikeComment(String commentId) {
    return _remoteDataSource.dislikeComment(commentId);
  }
}
