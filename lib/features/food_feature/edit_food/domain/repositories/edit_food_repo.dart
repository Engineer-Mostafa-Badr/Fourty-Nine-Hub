import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/models/restaurant_orders_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/update_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_statistics_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';

import '../../../../../core/error/failure.dart';
import '../../../../requests_history/domain/entities/food_order_entity.dart';

abstract class EditFoodRepo {
  // Future<Either<Failure, RestaurantOrdersModel>> getRestaurantOrders();
}
