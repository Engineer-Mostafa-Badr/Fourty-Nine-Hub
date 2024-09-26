import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/city_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/food_category_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/government_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_media_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';

// class Restaurant extends Equatable {
//   @JsonKey(name: "_id")
//   final String? id;
//   @JsonKey(name: "name")
//   final String? name;
//   @JsonKey(name: "restaurantMedia")
//   final List<RestaurantMediaModel>? restaurantMedia;
//   @JsonKey(name: "government")
//   final GovernmentModel? government;
//   @JsonKey(name: "city")
//   final CityModel? city;
//   @JsonKey(name: "address")
//   final String? address;
//   @JsonKey(name: "isActive")
//   final bool? isActive;
//   @JsonKey(name: "workFrom")
//   final String? workFrom;
//   @JsonKey(name: "workTo")
//   final String? workTo;
//   @JsonKey(name: "totalRating")
//   final int? totalRating;
//   @JsonKey(name: "countryCode")
//   final String? countryCode;
//   @JsonKey(name: "deliveryTime")
//   final String? deliveryTime;
//   @JsonKey(name: "deliveryFee")
//   final int? deliveryFee;
//   @JsonKey(name: "numberOfReviews")
//   final int? numberOfReviews;
//   @JsonKey(name: "MENU")
//   final List<RestaurantMneuModel>? menu;
//   @JsonKey(name: "id")
//   final String? datumId;
//   @JsonKey(name: "subcategoryId")
//   final SubCategoryModel? subcategoryId;
//   @JsonKey(name: "mainCategoryId")
//   final FoodCategoryModel? mainCategoryId;
//   const Restaurant({
//     this.id,
//     this.name,
//     this.restaurantMedia,
//     this.government,
//     this.city,
//     this.address,
//     this.isActive,
//     this.workFrom,
//     this.workTo,
//     this.totalRating,
//     this.countryCode,
//     this.deliveryTime,
//     this.deliveryFee,
//     this.numberOfReviews,
//     this.menu,
//     this.datumId,
//     this.subcategoryId,
//     this.mainCategoryId,
//   });
//   @override
//   List<Object?> get props => [
//         id,
//         name,
//         restaurantMedia,
//         government,
//         address,
//         mainCategoryId,
//         subcategoryId,
//         isActive,
//         workFrom,
//         workTo,
//         totalRating,
//         countryCode,
//         deliveryTime,
//         deliveryFee,
//         city,
//         numberOfReviews,
//         menu,
//         datumId,
//       ];
// }

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

  @JsonKey(name: "description") // New field
  final String? description; // New data field added

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
    this.description, // New data field in constructor
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
        description, // New field in props
      ];
}
