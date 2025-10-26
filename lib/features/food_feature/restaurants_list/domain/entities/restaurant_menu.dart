import 'package:equatable/equatable.dart';

class RestaurantMenu extends Equatable {
  final String? id;
  final String? restaurantId;
  final String? foodName;
  final double? price;
  final String? picture;
  final String? photo;
  final String? menuId;
  const RestaurantMenu({
    this.id,
    this.photo,
    this.restaurantId,
    this.foodName,
    this.price,
    this.picture,
    this.menuId,
  });
  @override
  List<Object?> get props => [
        id,
        restaurantId,
        photo,
        foodName,
        price,
        picture,
        menuId,
      ];
}
