import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

import '../repositories/reels_repository.dart';

class CreateReelUseCase extends UseCase<bool, CreateReelParams> {
  final ReelsRepository _repository;

  CreateReelUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(CreateReelParams params) {
    return _repository.createReel(params);
  }
}

class CreateReelParams {
  final String reelId;
  final int duration;

  CreateReelParams({required this.reelId, required this.duration});

  Map<String, dynamic> toJson() => {
        "duration": duration,
      };
}
