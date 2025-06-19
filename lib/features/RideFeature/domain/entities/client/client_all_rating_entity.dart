import '../../../data/models/client/driver_all_rating_model.dart';
class ClientAllRatingEntity {
  final String? id;
  final String? firstName;
  final String? pictureUrl;
  final String? gender;
  final double? rating;
  final int? totalRatings;
  final List<ClientRating>? ratings;

  ClientAllRatingEntity({
    this.id,
    this.firstName,
    this.pictureUrl,
    this.gender,
    this.rating,
    this.totalRatings,
    this.ratings,
  });
}

class ClientRating {
  final String? tripId;
  final int? rating;
  final String? comment;
  final DateTime? createdAt;

  ClientRating({
    this.tripId,
    this.rating,
    this.comment,
    this.createdAt,
  });
}




