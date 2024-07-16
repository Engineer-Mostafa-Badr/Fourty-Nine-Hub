import 'package:fourtyninehub/features/food_feature/food_cart/data/models/cart_item_model.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/data/models/master_model.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/domain/entities/food_cart_entity.dart';

class FoodCartModel extends FoodCartEntity {
  FoodCartModel(
      {required super.restuarantId,
      required super.restaurantItems,
      required super.id});
  factory FoodCartModel.fromJson(Map<String, dynamic> json) {
    return FoodCartModel(
      restuarantId: MasterModel.fromJson(json['restuarantId']),
      restaurantItems: (json['restaurantItems'] as List)
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
      id: json['_id'],
    );
  }
  
}
