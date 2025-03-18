import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/life_event_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/create_post_repo.dart';

class GetLifeEventCategoriesUseCase extends UseCase<List<LifeEventEntity>, NoParams> {
  final CreatePostRepo _repo;
  GetLifeEventCategoriesUseCase(this._repo);
  @override
  Future<Either<Failure, List<LifeEventEntity>>> call(NoParams params) {
    return _repo.getLifeEventCategories();
  }
}
