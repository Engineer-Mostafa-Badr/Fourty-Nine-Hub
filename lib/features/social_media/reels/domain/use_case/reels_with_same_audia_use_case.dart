import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/audio_reels_model.dart';

import '../repositories/reels_repository.dart';

class ReelsWithSameAudioUseCase
    extends UseCase<ReelsForAudioResponse, ReelsWithSameAudioParams> {
  final ReelsRepository _repository;

  ReelsWithSameAudioUseCase(this._repository);

  @override
  Future<Either<Failure, ReelsForAudioResponse>> call(
      ReelsWithSameAudioParams params) {
    return _repository.getReelsWithSameAudio(params);
  }
}

class ReelsWithSameAudioParams {
  final String audioId;
  int? page;
  int? limit;

  ReelsWithSameAudioParams({required this.audioId, this.page, this.limit});
}
