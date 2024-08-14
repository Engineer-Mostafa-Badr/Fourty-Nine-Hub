import 'cart_item_entity.dart';

class CartEntity {
  final String id;
  final List<CartItemEntity> allItems;
  CartEntity({required this.id, required this.allItems});
}
