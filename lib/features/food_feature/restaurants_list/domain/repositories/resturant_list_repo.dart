import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../data/models/food_category_model.dart';
import '../../data/models/restaurant_model.dart';

abstract class RestaurantListRepo {
Future<Either<Failure, List<RestaurantModel>>> getNearByReasturants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, List<RestaurantModel>>> getTrendingRestaurants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, List<FoodCategoryModel>>> getFoodCategories();

}
