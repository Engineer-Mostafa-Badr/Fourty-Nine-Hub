import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/city_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/government_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_media_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:json_annotation/json_annotation.dart';

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
  @JsonKey(name: "address")
  final String? address;
  @JsonKey(name: "isActive")
  final bool? isActive;
  @JsonKey(name: "workFrom")
  final String? workFrom;
  @JsonKey(name: "workTo")
  final String? workTo;
  @JsonKey(name: "totalRating")
  final int? totalRating;
  @JsonKey(name: "countryCode")
  final String? countryCode;
  @JsonKey(name: "deliveryTime")
  final String? deliveryTime;
  @JsonKey(name: "deliveryFee")
  final int? deliveryFee;
  @JsonKey(name: "numberOfReviews")
  final int? numberOfReviews;
  @JsonKey(name: "MENU")
  final List<RestaurantMneuModel>? menu;
  @JsonKey(name: "id")
  final String? datumId;
  const Restaurant({
    this.id,
    this.name,
    this.restaurantMedia,
    this.city,
    this.government,
    this.address,
    this.isActive,
    this.workFrom,
    this.workTo,
    this.totalRating,
    this.countryCode,
    this.deliveryTime,
    this.deliveryFee,
    this.numberOfReviews,
    this.menu,
    this.datumId,
  });
  @override
  List<Object?> get props => [
        id,
        name,
        restaurantMedia,
        government,
        address,
        isActive,
        workFrom,
        workTo,
        totalRating,
        countryCode,
        deliveryTime,
        deliveryFee,
        city,
        numberOfReviews,
        menu,
        datumId,
      ];
}
