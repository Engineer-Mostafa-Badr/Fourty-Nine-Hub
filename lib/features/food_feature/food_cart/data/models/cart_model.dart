import '../../domain/entities/cart_entity.dart';

import 'cart_item_model.dart';

class CartModel extends CartEntity {
  CartModel({required super.id, required super.allItems});
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        id: json['_id'],
        allItems: (json['allItems'] as List)
            .map((e) => CartItemModel.fromJson(e))
            .toList());
  }
}
