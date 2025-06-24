import '../../../data/models/client/driver_all_rating_model.dart';
class DriverAllRatingEntity {
  final String? id;
  final String? firstName;
  final String? pictureUrl;
  final String? gender;
  final double? rating;
  final int? totalRatings;
  final List<DriverRating>? ratings;

  DriverAllRatingEntity({
    this.id,
    this.firstName,
    this.pictureUrl,
    this.gender,
    this.rating,
    this.totalRatings,
    this.ratings,
  });
}

class DriverRating {
  final String? tripId;
  final int? rating;
  final String? comment;
  final DateTime? createdAt;

  DriverRating({
    this.tripId,
    this.rating,
    this.comment,
    this.createdAt,
  });
}




