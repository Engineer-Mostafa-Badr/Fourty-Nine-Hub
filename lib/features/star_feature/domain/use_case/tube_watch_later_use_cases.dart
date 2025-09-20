import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/tube_video_models.dart';
import '../repository/star_repository.dart';

// Add Video to Watch Later Use Case
class AddVideoToWatchLaterUseCase extends UseCase<String, String> {
  final StarRepository _starRepository;

  AddVideoToWatchLaterUseCase(this._starRepository);

  @override
  Future<Either<Failure, String>> call(String videoId) async {
    return await _starRepository.addVideoToWatchLater(videoId);
  }
}

// Remove Video from Watch Later Use Case
class RemoveVideoFromWatchLaterUseCase extends UseCase<String, String> {
  final StarRepository _starRepository;

  RemoveVideoFromWatchLaterUseCase(this._starRepository);

  @override
  Future<Either<Failure, String>> call(String videoId) async {
    return await _starRepository.removeVideoFromWatchLater(videoId);
  }
}

// Get Watch Later Videos Use Case
class GetWatchLaterVideosUseCase extends UseCase<List<TubeVideoModel>, NoParams> {
  final StarRepository _starRepository;

  GetWatchLaterVideosUseCase(this._starRepository);

  @override
  Future<Either<Failure, List<TubeVideoModel>>> call(NoParams params) async {
    return await _starRepository.getWatchLaterVideos();
  }
}