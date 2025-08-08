import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../entities/activity_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/create_post_repo.dart';

class GetActivitiesUseCase extends UseCase<List<ActivityEntity>, PaginationParams> {
  final CreatePostRepo _repo;
  GetActivitiesUseCase(this._repo);
  @override
  Future<Either<Failure, List<ActivityEntity>>> call(PaginationParams params) {
    return _repo.getActivitiesList(params);
  }
}
