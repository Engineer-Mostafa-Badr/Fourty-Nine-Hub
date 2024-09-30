import '../../../../ride/RideRequest/data/models/driver_review_model.dart';
import '../../data/models/cuisine_model.dart';
import 'restaurant_location_entity.dart';

class RestaurantEntity {
  final String id;
  final String name;
  final String description;
  final List<String> image;
  final List<RestaurantLocationEntity> locations;
  final bool available;
  final String deliveryTime;
  final String deliveryFee;
  final double rate;
   bool? isFavorite;
  final int? numberOfContent;
  final int numberOfReviews;
  final CuisineModel? cuisine;
  final List<ReviewModel>? reviews;

  RestaurantEntity(
      {required this.id,
      required this.name,
      this.numberOfContent,
      required this.description,
      required this.image,
      required this.available,
      this.isFavorite,
      required this.deliveryTime,
      required this.deliveryFee,
      required this.rate,
      required this.numberOfReviews,
      required this.locations,
      this.cuisine,
      this.reviews});
}
