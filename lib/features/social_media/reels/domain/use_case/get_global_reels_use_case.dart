import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/new_reels_model.dart';

import '../repositories/reels_repository.dart';

class GetGlobalReelsUseCase extends UseCase<ReelsResponse, PaginationParams> {
  final ReelsRepository _repository;

  GetGlobalReelsUseCase(this._repository);

  @override
  Future<Either<Failure, ReelsResponse>> call(PaginationParams params) {
    return _repository.getGlobalReels(params);
  }
}
