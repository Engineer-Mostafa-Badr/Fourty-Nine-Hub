import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/city_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/food_category_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/government_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_media_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_2_model.g.dart';

@JsonSerializable()
class Restaurant2Model extends Restaurant {
  const Restaurant2Model({
    super.id,
    super.name,
    super.address,
    super.countryCode,
    super.datumId,
    super.city,
    super.mainCategoryId,
    super.subcategoryId,
    super.government,
    super.isActive,
    super.deliveryTime,
    super.deliveryFee,
    super.menu,
    super.numberOfReviews,
    super.restaurantMedia,
    super.totalRating,
    super.workFrom,
    super.workTo,
  });

  factory Restaurant2Model.fromJson(Map<String, dynamic> json) =>
      _$Restaurant2ModelFromJson(json);

  Map<String, dynamic> toJson() => _$Restaurant2ModelToJson(this);
}
