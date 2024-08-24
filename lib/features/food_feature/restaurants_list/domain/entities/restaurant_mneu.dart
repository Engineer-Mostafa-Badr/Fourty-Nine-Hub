import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_media_model.dart';

class RestaurantMneu extends Equatable {
  final String? id;
  final String? restaurantId;
  final String? foodName;
  final double? price;
  final RestaurantMediaModel? picture;
  final String? photo;
  final String? menuId;
  const RestaurantMneu({
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
