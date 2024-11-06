import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/models/restaurant_orders_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/update_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_statistics_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';

import 'package:fourtyninehub/features/requests_history/domain/entities/food_order_entity.dart';

import '../../domain/repositories/edit_food_repo.dart';
import '../datasources/edit_food_remote_datasource.dart';

class EditFoodRepoImpl implements EditFoodRepo {
  final EditFoodRemoteDataSource _remoteDataSource;
  EditFoodRepoImpl(this._remoteDataSource);
  // @override
  // Future<Either<Failure, bool>> approveOrder({required int id}) async {
  //   return await _remoteDataSource.approveOrder(id: id);
  // }


}
