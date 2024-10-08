import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/city_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/food_category_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/government_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_media_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';

@JsonSerializable(explicitToJson: true)
class Restaurant extends Equatable {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "name")
  final String? name;

  @JsonKey(name: "restaurantMedia")
  final List<RestaurantMediaModel>? restaurantMedia;

  @JsonKey(name: "government")
  final GovernmentModel? government;

  @JsonKey(name: "city")
  final CityModel? city;

  @JsonKey(name: "isActive")
  final bool? isActive;

  @JsonKey(name: "subscriptionType")
  final String? subscriptionType;

  @JsonKey(name: "totalRating")
  final double? totalRating;

  @JsonKey(name: "numberOfReviews")
  final int? numberOfReviews;

  @JsonKey(name: "MENU")
  final List<RestaurantMneuModel>? menu;

  @JsonKey(name: "subcategoryId")
  final SubCategoryModel? subcategoryId;

  @JsonKey(name: "mainCategoryId")
  final FoodCategoryModel? mainCategoryId;

  @JsonKey(name: "isFavorite")
  final bool? isFavorite;

  @JsonKey(name: "enableOrDisableChat")
  final String? enableOrDisableChat;

  @JsonKey(name: "description")
  final String? description;

  const Restaurant({
    this.id,
    this.name,
    this.restaurantMedia,
    this.government,
    this.city,
    this.isActive,
    this.subscriptionType,
    this.totalRating,
    this.numberOfReviews,
    this.menu,
    this.subcategoryId,
    this.mainCategoryId,
    this.isFavorite,
    this.enableOrDisableChat,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        restaurantMedia,
        government,
        city,
        isActive,
        subscriptionType,
        totalRating,
        numberOfReviews,
        menu,
        subcategoryId,
        mainCategoryId,
        isFavorite,
        enableOrDisableChat,
        description,
      ];
}
