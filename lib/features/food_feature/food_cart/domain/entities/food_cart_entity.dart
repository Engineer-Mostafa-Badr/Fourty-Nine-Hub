import 'master_entity.dart';

import 'cart_item_entity.dart';

class FoodCartEntity {
  MasterEntity restuarantId;
  List<CartItemEntity> restaurantItems;
  String id;

  FoodCartEntity(
      {required this.restuarantId,
      required this.restaurantItems,
      required this.id});
}
