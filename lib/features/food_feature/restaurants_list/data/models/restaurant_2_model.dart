// import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/city_model.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/food_category_model.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/government_model.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_media_model.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
// import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
// import 'package:json_annotation/json_annotation.dart';
//
// part 'restaurant_2_model.g.dart';
//
// @JsonSerializable(explicitToJson: true)
// class Restaurant2Model extends Restaurant {
//   const Restaurant2Model(
//       {super.id,
//       super.name,
//       super.number,
//       super.subscriptionType, // Added subscriptionType
//       super.city,
//       super.mainCategoryId,
//       super.subcategoryId,
//       super.government,
//       super.isActive,
//       super.menu,
//       super.numberOfReviews,
//       super.restaurantMedia,
//       super.totalRating,
//       super.description, // Included the new description field
//       super.isFavorite,
//       super.enableOrDisableChat});
//
//   factory Restaurant2Model.fromJson(Map<String, dynamic> json) => _$Restaurant2ModelFromJson(json);
//
//   Map<String, dynamic> toJson() => _$Restaurant2ModelToJson(this);
// }

import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/city_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/food_category_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/government_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_media_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'restaurant_mneu_model.dart';

part 'restaurant_2_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Restaurant2Model extends Restaurant {
  Restaurant2Model({
    super.id,
    super.name,
    super.number, // Corresponds to "phone" in the JSON
    super.subscriptionType, // Added subscriptionType from JSON
    super.city, // City object
    super.mainCategoryId, // MainCategory object
    super.subcategoryId, // SubCategory object
    super.government, // Government object
    super.isActive, // IsActive status
    super.menu, // Menu List
    super.numberOfReviews,
    super.restaurantMedia, // List of Restaurant Media
    super.totalRating,
    super.description, // Description is not in your JSON, so this may not be used
    super.isFavorite,
    super.enableOrDisableChat, // Chat enabled/disabled status
  });

  // Factory method for creating an instance from a JSON map
  factory Restaurant2Model.fromJson(Map<String, dynamic> json) =>
      _$Restaurant2ModelFromJson(json);

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() => _$Restaurant2ModelToJson(this);
}
