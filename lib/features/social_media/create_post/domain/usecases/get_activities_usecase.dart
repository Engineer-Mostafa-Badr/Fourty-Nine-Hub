import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/create_post_repo.dart';

class GetActivitiesUseCase extends UseCase<List<ActivityEntity>, NoParams> {
  final CreatePostRepo _repo;
  GetActivitiesUseCase(this._repo);
  @override
  Future<Either<Failure, List<ActivityEntity>>> call(NoParams params) {
    return _repo.getActivitiesList();
  }
}
