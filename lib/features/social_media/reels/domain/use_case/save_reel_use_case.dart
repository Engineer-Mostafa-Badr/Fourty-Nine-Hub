import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/save_reel_model.dart';

import '../repositories/reels_repository.dart';

class SaveReelUseCase extends UseCase<ReelSaveResponse, String> {
  final ReelsRepository _repository;

  SaveReelUseCase(this._repository);

  @override
  Future<Either<Failure, ReelSaveResponse>> call(String params) {
    return _repository.saveReel(params);
  }
}
