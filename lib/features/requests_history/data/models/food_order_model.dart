import 'package:fourtyninehub/features/ads_feature/ads/data/models/publisher_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_model.dart';
import 'package:fourtyninehub/features/requests_history/data/models/address_model.dart';

import '../../../food_feature/restaurant_details/data/models/selected_meal_model.dart';
import '../../domain/entities/food_order_entity.dart';

class FoodOrderModel extends FoodOrderEntity {
  FoodOrderModel(
      {required super.id,
      required super.address,
      required super.meals,
      super.user,
      required super.restaurant});

  factory FoodOrderModel.fromJson(Map<String, dynamic> json) {
    return FoodOrderModel(
      id: json['id'],
      address: AddressModel.fromJson(json['address']),
      meals: (json['meals'] as List).map((e) => SelectedMealModel.fromJson(e)).toList(),
      restaurant: RestaurantModel.fromJson(json['restaurant']),
      user: json['user']!=null? PublisherModel.fromJson(json['user']):null,
    );
  }
}
