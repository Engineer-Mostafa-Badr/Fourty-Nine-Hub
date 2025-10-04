import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../repository/star_repository.dart';

/// UseCase for rating a video
class RateVideoUseCase {
  final StarRepository repository;

  RateVideoUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String videoId,
    required double rating,
  }) async {
    return await repository.rateTubeVideo(videoId, rating);
  }
}
