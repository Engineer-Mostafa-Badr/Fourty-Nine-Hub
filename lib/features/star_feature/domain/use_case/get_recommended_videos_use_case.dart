import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/tube_video_models.dart';
import '../repository/star_repository.dart';

class GetRecommendedVideosParams {
  final String videoId;
  final int page;
  final int limit;

  GetRecommendedVideosParams({
    required this.videoId,
    this.page = 1,
    this.limit = 10,
  });
}

class GetRecommendedVideosUseCase {
  final StarRepository _repository;

  GetRecommendedVideosUseCase(this._repository);

  Future<Either<Failure, List<TubeVideoModel>>> call(
      GetRecommendedVideosParams params) async {
    return await _repository.getRecommendedVideos(
      params.videoId,
      params.page,
      params.limit,
    );
  }
}
