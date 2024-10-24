import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/save_reel_model.dart';

import '../repositories/reels_repository.dart';

class SaveReelUseCase extends UseCase<ReelSaveResponse, String> {
  final ReelsRepository _repository;

  SaveReelUseCase(this._repository);

  @override
  Future<Either<Failure, ReelSaveResponse>> call(String params) {
    return _repository.saveReel(params);
  }
}
