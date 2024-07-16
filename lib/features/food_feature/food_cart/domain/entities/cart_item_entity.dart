import 'package:fourtyninehub/features/food_feature/food_cart/domain/entities/master_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/entities/option_entity.dart';

class CartItemEntity {
  MasterEntity foodId;
  int quantity;
  num price;
  OptionEntity option;
  String id;

  CartItemEntity(
      {
        required this.foodId,required  this.quantity,required  this.price, required this.option, required this.id});
}
