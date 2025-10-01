import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../repository/star_repository.dart';

/// UseCase for toggling watch later status of a video
class ToggleWatchLaterUseCase {
  final StarRepository repository;

  ToggleWatchLaterUseCase(this.repository);

  Future<Either<Failure, String>> addToWatchLater(String videoId) async {
    return await repository.addVideoToWatchLater(videoId);
  }

  Future<Either<Failure, String>> removeFromWatchLater(String videoId) async {
    return await repository.removeVideoFromWatchLater(videoId);
  }
}
