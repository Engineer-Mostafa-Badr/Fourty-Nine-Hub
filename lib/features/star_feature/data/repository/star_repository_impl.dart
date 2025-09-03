import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../data_source/star_remote_data_source.dart';
import '../../domain/entity/banner_talent_entity.dart';
import '../../domain/entity/star_entity.dart';
import '../../domain/entity/star_winner_entity.dart';
import '../../domain/repository/star_repository.dart';
import '../../domain/use_case/fetch_all_star_use_case.dart';
import '../../domain/use_case/upload_my_star_use_case.dart';
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
}
