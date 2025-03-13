import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/life_event_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/create_post_repo.dart';

class GetLifeEventSubCategoriesUseCase extends UseCase<List<LifeEventEntity>, String> {
  final CreatePostRepo _repo;
  GetLifeEventSubCategoriesUseCase(this._repo);
  @override
  Future<Either<Failure, List<LifeEventEntity>>> call(String params) {
    return _repo.getLifeEventSubCategories(params);
  }
}
