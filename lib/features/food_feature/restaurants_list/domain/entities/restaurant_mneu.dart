import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_media_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_media.dart';
import 'package:json_annotation/json_annotation.dart';

class RestaurantMneu extends Equatable {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "restaurantId")
  final String? restaurantId;
  @JsonKey(name: "foodName")
  final String? foodName;
  @JsonKey(name: "price")
  final int? price;
  @JsonKey(name: "picture")
  final RestaurantMediaModel? picture;
  @JsonKey(name: "id")
  final String? menuId;
  const RestaurantMneu({
    this.id,
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
        foodName,
        price,
        picture,
        menuId,
      ];
}
