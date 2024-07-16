import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_location_model.dart';

import '../../../../../res/style/const.dart';
import '../../../../ride/RideRequest/data/models/driver_review_model.dart';
import '../../domain/entities/restaurant_entity.dart';
import 'cuisine_model.dart';

class RestaurantModel extends RestaurantEntity {
  RestaurantModel(
      {required super.id,
      required super.name,
      super.reviews,
      required super.description,
      required super.image,
      required super.available,
      required super.deliveryTime,
      required super.deliveryFee,
      required super.rate,
      required super.numberOfReviews,
      super.cuisine,
      required super.locations});

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
        id: json['_id'],
        name: getLang() == 'ar' ? json['name_en'] : json['name_en'],
        description: json['desc'],
        image: json['media'] != null
            ? (json['media'] as List)
                .map((e) => e['mediaKey'] as String)
                .toList()
            : [UIConst.imagePlaceHolder],
        locations: json['location'] == null
            ? []
            : (json['location'] as List)
                .map((e) => RestaurantLocationModel.fromJson(e))
                .toList(),
        available: json['available'] ?? false,
        deliveryTime: json['delivery_time'] ?? '0',
        deliveryFee: json['delivery_fee'] ?? '0',
        rate: json['totalRating'] ?? 5,
        numberOfReviews: json['numberOfReviews'] ?? 0,
        cuisine: json['cuisine'] != null
            ? CuisineModel.fromJson(json['cuisine'])
            : null,
        reviews: json['reviews'] != null
            ? (json['reviews'] as List)
                .map((e) => ReviewModel.fromJson(e))
                .toList()
            : []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;

    data['available'] = available;
    data['delivery_time'] = deliveryTime;
    data['delivery_fee'] = deliveryFee;
    data['rate'] = rate;
    data['number_of_reviews'] = numberOfReviews;
    if (cuisine != null) {
      data['cuisine'] = cuisine!.toJson();
    }
    return data;
  }
}
