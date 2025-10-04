import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../repository/star_repository.dart';

/// UseCase for toggling favorite status of a video
class ToggleFavoriteVideoUseCase {
  final StarRepository repository;

  ToggleFavoriteVideoUseCase(this.repository);

  Future<Either<Failure, String>> addToFavorite(String videoId) async {
    return await repository.addVideoToFavorite(videoId);
  }

  Future<Either<Failure, String>> removeFromFavorite(String videoId) async {
    return await repository.removeVideoFromFavorite(videoId);
  }
}
