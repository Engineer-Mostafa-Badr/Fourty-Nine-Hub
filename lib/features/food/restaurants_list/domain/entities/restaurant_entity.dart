import 'package:fourtyninehub/core/data/models/review_model.dart';
import 'package:fourtyninehub/features/food/restaurants_list/data/models/cuisine_model.dart';

class RestaurantEntity {
  final int id;
  final String name;
  final String description;
  final String image;
  final String banner;
  final bool available;
  final String deliveryTime;
  final num deliveryFee;
  final double rate;
  final int numberOfReviews;
  final CuisineModel? cuisine;
  final List<ReviewModel>? reviews;

  RestaurantEntity(
      {required this.id,
      required this.name,
      required this.description,
      required this.image,
      required this.banner,
      required this.available,
      required this.deliveryTime,
      required this.deliveryFee,
      required this.rate,
      required this.numberOfReviews,
      this.cuisine, this.reviews});
}
