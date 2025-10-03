import 'package:dartz/dartz.dart';
import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../models/subscribtion_plans_model.dart';
import '../models/subscription_amount_model.dart';
import '../../domain/entities/subscription_amount_entity.dart';
import '../../domain/entities/subscription_plans_entity.dart';
import '../../domain/usecases/subscribe_usecase.dart';

import '../../../../core/error/failure.dart';

abstract class SubscribeRemoteDataSource {
  Future<Either<Failure, SubscriptionPlansEntity>> getSubscriptionPlans(
      {required String subCategoryId});
  Future<Either<Failure, bool>> isUserSubscribed(
      {required String subCategoryId});

  Future<Either<Failure, List<SubscriptionAmountEntity>>>
      getActiveSubscriptionAmounts();

  Future<Either<Failure, bool>> subscribe({required SubscribeParams data});
}

class SubscribeRemoteDataSourceImpl implements SubscribeRemoteDataSource {
  final ApiConsumer _apiConsumer;
  SubscribeRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, SubscriptionPlansEntity>> getSubscriptionPlans(
      {required String subCategoryId}) async {
    final response = await _apiConsumer.get(
      EndPoints.getSubscriptionPlans(subCategoryId),
    );
    return response.fold((l) => Left(l),
        (data) => Right(SubscriptionPlansModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, bool>> isUserSubscribed(
      {required String subCategoryId}) async {
    final response =
        await _apiConsumer.get(EndPoints.checkUserSubscription(subCategoryId));
    return response.fold((l) => Left(l), (data) => Right(data['data'] as bool));
  }

  @override
  Future<Either<Failure, bool>> subscribe(
      {required SubscribeParams data}) async {
    final response =
        await _apiConsumer.post(EndPoints.subscribe, data: data.toJson());
    return response.fold(
        (l) => Left(l), (data) => Right(data['status'] as bool));
  }

  @override
  Future<Either<Failure, List<SubscriptionAmountEntity>>>
      getActiveSubscriptionAmounts() async {
    final response =
        await _apiConsumer.get(EndPoints.getActiveSubscriptionAmounts);

    return response.fold(
      (l) => Left(l),
      (data) => Right((data['data'] as List)
          .map((e) => SubscriptionAmountModel.fromJson(e))
          .toList()),
    );
  }
}
