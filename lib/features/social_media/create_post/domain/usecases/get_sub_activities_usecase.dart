import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/create_post_repo.dart';

class GetSubActivitiesUseCase extends UseCase<List<ActivityEntity>, GetSubActivitiesParams> {
  final CreatePostRepo _repo;
  GetSubActivitiesUseCase(this._repo);
  @override
  Future<Either<Failure, List<ActivityEntity>>> call(GetSubActivitiesParams params) {
    return _repo.getSubActivitiesList(params);
  }
}

class GetSubActivitiesParams{
  final int limit;
  final int page;
  final String id;

  GetSubActivitiesParams({required this.limit, required this.page, required this.id});
}