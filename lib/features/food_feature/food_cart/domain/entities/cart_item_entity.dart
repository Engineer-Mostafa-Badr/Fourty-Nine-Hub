import 'master_entity.dart';
import '../../../restaurant_details/domain/entities/option_entity.dart';

class CartItemEntity {
  MasterEntity foodId;
  int quantity;
  num price;
  OptionEntity option;
  String id;

  CartItemEntity(
      {required this.foodId,
      required this.quantity,
      required this.price,
      required this.option,
      required this.id});
}
