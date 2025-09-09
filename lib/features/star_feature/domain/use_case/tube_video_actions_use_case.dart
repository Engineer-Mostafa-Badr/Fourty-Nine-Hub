import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repository/star_repository.dart';

// Combined parameters class for tube video operations
class TubeVideoActionParams {
  final String videoId;
  final String? action; // 'like', 'dislike', 'view'

  TubeVideoActionParams({
    required this.videoId,
    this.action,
  });
}

// Enhanced use case for multiple video actions
class TubeVideoActionsUseCase extends UseCase<bool, TubeVideoActionParams> {
  final StarRepository _starRepository;

  TubeVideoActionsUseCase(this._starRepository);

  @override
  Future<Either<Failure, bool>> call(TubeVideoActionParams params) async {
    switch (params.action?.toLowerCase()) {
      case 'like':
        return await _starRepository.likeTubeVideo(params.videoId);
      case 'dislike':
        return await _starRepository.dislikeTubeVideo(params.videoId);
      case 'view':
        return await _starRepository.incrementTubeVideoView(params.videoId);
      default:
        return Left(ValidationFailure('Invalid action: ${params.action}'));
    }
  }
}
