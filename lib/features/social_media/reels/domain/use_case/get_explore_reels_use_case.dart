import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';

import '../repositories/reels_repository.dart';

class GetExploreReelsUseCase extends UseCase<ReelsResponse, PaginationParams> {
  final ReelsRepository _repository;

  GetExploreReelsUseCase(this._repository);

  @override
  Future<Either<Failure, ReelsResponse>> call(PaginationParams params) {
    return _repository.getExploreReels(params);
  }
}
