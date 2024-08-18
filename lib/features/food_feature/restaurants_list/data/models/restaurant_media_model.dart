import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_media.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_media_model.g.dart';

@JsonSerializable()
class RestaurantMediaModel extends RestaurantMedia {
  const RestaurantMediaModel({
    super.id,
    super.mediaKey,
  });

  factory RestaurantMediaModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantMediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantMediaModelToJson(this);
}
