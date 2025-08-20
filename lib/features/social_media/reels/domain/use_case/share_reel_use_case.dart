import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/share_reel_model.dart';

import '../repositories/reels_repository.dart';

class ShareReelUseCase extends UseCase<ReelShareResponse, String> {
  final ReelsRepository _repository;

  ShareReelUseCase(this._repository);

  @override
  Future<Either<Failure, ReelShareResponse>> call(String params) {
    return _repository.shareReel(params);
  }
}
