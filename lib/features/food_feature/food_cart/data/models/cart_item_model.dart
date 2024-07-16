import 'package:fourtyninehub/features/food_feature/food_cart/data/models/master_model.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/domain/entities/cart_item_entity.dart';

import '../../../restaurant_details/data/models/option_model.dart';

class CartItemModel extends CartItemEntity {
  CartItemModel(
      {required super.foodId,
      required super.quantity,
      required super.price,
      required super.option,
      required super.id});
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      foodId: json['foodId'] == null
          ? MasterModel(id: '0', name: 'undefined')
          : MasterModel.fromJson(json['foodId']),
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? 0,
      option: json['option'] == null
          ? OptionModel(id: 'id', name: 'undefined', price: 0)
          : OptionModel.fromJson(json['option']),
      id: json['_id'],
    );
  }
}
