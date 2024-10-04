import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/city_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/food_category_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/government_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_media_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_2_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Restaurant2Model extends Restaurant {
  const Restaurant2Model(
      {super.id,
      super.name,
      super.number,
      super.subscriptionType, // Added subscriptionType
      super.city,
      super.mainCategoryId,
      super.subcategoryId,
      super.government,
      super.isActive,
      super.menu,
      super.numberOfReviews,
      super.restaurantMedia,
      super.totalRating,
      super.description, // Included the new description field
      super.isFavorite,
      super.enableOrDisableChat});

  factory Restaurant2Model.fromJson(Map<String, dynamic> json) =>
      _$Restaurant2ModelFromJson(json);

  Map<String, dynamic> toJson() => _$Restaurant2ModelToJson(this);
}
