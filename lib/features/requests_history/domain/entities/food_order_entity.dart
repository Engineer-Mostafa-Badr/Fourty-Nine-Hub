import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/entities/selected_meal_entity.dart';

import '../../../food_feature/restaurants_list/domain/entities/restaurant_entity.dart';
import 'address_entity.dart';

class FoodOrderEntity {
  final int id;
  final AddressEntity address;
  final List<SelectedMealEntity> meals;
  final RestaurantEntity restaurant;

  FoodOrderEntity(
      {required this.id,
      required this.address,
      required this.meals,
      required this.restaurant});
}
