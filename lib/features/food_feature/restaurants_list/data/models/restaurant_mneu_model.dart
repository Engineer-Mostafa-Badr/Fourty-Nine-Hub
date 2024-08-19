import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_media_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_mneu_model.g.dart';

@JsonSerializable()
class RestaurantMneuModel extends RestaurantMneu {
  const RestaurantMneuModel({
    super.id,
    super.restaurantId,
    super.foodName,
    super.price,
    super.picture,
    super.menuId,
  });
  factory RestaurantMneuModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantMneuModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantMneuModelToJson(this);
}
