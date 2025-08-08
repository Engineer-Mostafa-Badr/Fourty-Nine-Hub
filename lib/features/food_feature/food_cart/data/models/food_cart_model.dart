import 'cart_item_model.dart';
import 'master_model.dart';
import '../../domain/entities/food_cart_entity.dart';

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
