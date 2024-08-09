import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/features/subscribe/data/models/subscribtion_plans_model.dart';
import 'package:fourtyninehub/features/subscribe/domain/entities/subscribtion_plans_entity.dart';
import 'package:fourtyninehub/features/subscribe/domain/usecases/subscribe_usecase.dart';

import '../../../../core/api/end_points.dart';
import '../../../../core/error/failure.dart';

abstract class SubscribeRemoteDataSource {
  Future<Either<Failure, SubscribtionPlansEntity>> getSubscribtionPlans(
      {required String subCategoryId});
  Future<Either<Failure, bool>> isUserSubscribed(
      {required String subCategoryId});

  Future<Either<Failure, bool>> subscribe({required SubscribeParams data});
}

class SubscribeRemoteDataSourceImpl implements SubscribeRemoteDataSource {
  final ApiConsumer _apiConsumer;
  SubscribeRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, SubscribtionPlansEntity>> getSubscribtionPlans(
      {required String subCategoryId}) async {
    final response = await _apiConsumer
        .get(EndPoints.getSubscribtionPlans, queryParameters: {
      'subCategoryId': subCategoryId,
    });
    return response.fold((l) => Left(l),
        (data) => Right(SubscriptionPlansModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, bool>> isUserSubscribed(
      {required String subCategoryId}) async {
    final response =
        await _apiConsumer.get(EndPoints.checkUserSubscribtion(subCategoryId));
    return response.fold((l) => Left(l), (data) => Right(data['data'] as bool));
  }

  @override
  Future<Either<Failure, bool>> subscribe(
      {required SubscribeParams data}) async {
    final response = await _apiConsumer.get(EndPoints.subscribe);
       return response.fold((l) => Left(l), (data) => Right(data['success'] as bool)); 
  }
}
