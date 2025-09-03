import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/tube_video_models.dart';
import '../entity/banner_talent_entity.dart';
import '../entity/star_entity.dart';
import '../entity/star_winner_entity.dart';
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
  Future<Either<Failure, bool>> uploadMyStar(StarParams params);
  Future<Either<Failure, bool>> deleteMyStar({required String id});

  // New Tube Video methods
  Future<Either<Failure, TubeVideoListResponse>> fetchAllTubeVideos(
      StarPaginationParams params);
  Future<Either<Failure, TubeVideoListResponse>> fetchMyTubeVideos(
      StarPaginationParams params);
  Future<Either<Failure, StarEntity>> fetchTubeVideoDetails(String videoId);
  Future<Either<Failure, bool>> likeTubeVideo(String videoId);
  Future<Either<Failure, bool>> dislikeTubeVideo(String videoId);
  Future<Either<Failure, bool>> incrementTubeVideoView(String videoId);
}
