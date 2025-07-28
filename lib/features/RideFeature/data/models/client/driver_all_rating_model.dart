import '../../../domain/entities/client/driver_all_rating_entity.dart';

class DriverAllRatingModel extends DriverAllRatingEntity {
  DriverAllRatingModel({
    super.id,
    super.firstName,
    super.pictureUrl,
    super.gender,
    super.rating,
    super.totalRatings,
    super.ratings,
  });

  factory DriverAllRatingModel.fromJson(Map<String, dynamic> json) {
    final driverDetails = json['data']?['driverDetails'] ?? {};
    final summary = driverDetails['summary'] ?? {};

    List<DriverRating>? ratingsList;
    if (json['data']?['ratings'] != null) {
      ratingsList = List<DriverRating>.from(
        (json['data']['ratings'] as List).map(
              (e) => DriverRating(
            tripId: e['tripId'] as String?,
            rating: e['rating'] as int?,
            comment: e['comment'] as String?,
            createdAt:
            e['createdAt'] == null ? null : DateTime.parse(e['createdAt']),
          ),
        ),
      );
    }

    return DriverAllRatingModel(
      id: driverDetails['id'] as String?,
      firstName: driverDetails['firstName'] as String?,
      pictureUrl: driverDetails['pictureUrl'] as String?,
      gender: driverDetails['gender'] as String?,
      rating: (summary['rating'] != null)
          ? (summary['rating'] is int
          ? (summary['rating'] as int).toDouble()
          : summary['rating'] as double?)
          : null,
      totalRatings: summary['totalRatings'] as int?,
      ratings: ratingsList,
    );
  }
}