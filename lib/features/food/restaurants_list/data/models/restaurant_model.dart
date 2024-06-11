import 'package:fourtyninehub/core/data/models/review_model.dart';

import '../../domain/entities/restaurant_entity.dart';
import 'cuisine_model.dart';

class RestaurantModel extends RestaurantEntity {
  RestaurantModel(
      {required super.id,
      required super.name,
      super.reviews,
      required super.description,
      required super.image,
      required super.banner,
      required super.available,
      required super.deliveryTime,
      required super.deliveryFee,
      required super.rate,
      required super.numberOfReviews,
      super.cuisine});

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        image: json['image'],
        banner: json['banner'],
        available: json['available'],
        deliveryTime: json['delivery_time'],
        deliveryFee: json['delivery_fee'],
        rate: json['rate'],
        numberOfReviews: json['number_of_reviews'],
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
    data['banner'] = banner;
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
