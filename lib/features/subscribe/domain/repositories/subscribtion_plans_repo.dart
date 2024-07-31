import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/subscribtion_plans_entity.dart';
import '../usecases/subscribe_usecase.dart';

abstract class SubscribtionPlansRepo {
  Future<Either<Failure, SubscribtionPlansEntity>> getSubscribtionPlans(
      {required String subCategoryId});
  Future<Either<Failure, bool>> isUserSubscribed(
      {required String subCategoryId});
        Future<Either<Failure, bool>> subscribe({required SubscribeParams data});

}