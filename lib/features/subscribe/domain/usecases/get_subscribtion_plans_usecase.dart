import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../entities/subscribtion_plans_entity.dart';
import '../repositories/subscribtion_plans_repo.dart';

class GetSubscribtionPlansUseCase extends UseCase<SubscribtionPlansEntity, String> {
  final SubscribtionPlansRepo _repo;
  GetSubscribtionPlansUseCase(this._repo);
  @override
  Future<Either<Failure, SubscribtionPlansEntity>> call(String params) {
    return _repo.getSubscribtionPlans(subCategoryId: params);
  }
}
