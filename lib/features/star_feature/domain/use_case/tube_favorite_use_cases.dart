import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/tube_video_models.dart';
import '../repository/star_repository.dart';

// Add Video to Favorite Use Case
class AddVideoToFavoriteUseCase extends UseCase<String, String> {
  final StarRepository _starRepository;

  AddVideoToFavoriteUseCase(this._starRepository);

  @override
  Future<Either<Failure, String>> call(String videoId) async {
    return await _starRepository.addVideoToFavorite(videoId);
  }
}

// Remove Video from Favorite Use Case
class RemoveVideoFromFavoriteUseCase extends UseCase<String, String> {
  final StarRepository _starRepository;

  RemoveVideoFromFavoriteUseCase(this._starRepository);

  @override
  Future<Either<Failure, String>> call(String videoId) async {
    return await _starRepository.removeVideoFromFavorite(videoId);
  }
}

// Get Favorite Videos Use Case
class GetFavoriteVideosUseCase extends UseCase<List<TubeVideoModel>, NoParams> {
  final StarRepository _starRepository;

  GetFavoriteVideosUseCase(this._starRepository);

  @override
  Future<Either<Failure, List<TubeVideoModel>>> call(NoParams params) async {
    return await _starRepository.getFavoriteVideos();
  }
}