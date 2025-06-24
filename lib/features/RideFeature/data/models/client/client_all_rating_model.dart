import '../../../domain/entities/client/client_all_rating_entity.dart';
import '../../../domain/entities/client/driver_all_rating_entity.dart';

class ClientAllRatingModel extends ClientAllRatingEntity {
  ClientAllRatingModel({
    String? id,
    String? firstName,
    String? pictureUrl,
    String? gender,
    double? rating,
    int? totalRatings,
    List<ClientRating>? ratings,
  }) : super(
    id: id,
    firstName: firstName,
    pictureUrl: pictureUrl,
    gender: gender,
    rating: rating,
    totalRatings: totalRatings,
    ratings: ratings,
  );

  factory ClientAllRatingModel.fromJson(Map<String, dynamic> json) {
    final driverDetails = json['data']?['clientDetails'] ?? {};
    final summary = driverDetails['summary'] ?? {};

    List<ClientRating>? ratingsList;
    if (json['data']?['ratings'] != null) {
      ratingsList = List<ClientRating>.from(
        (json['data']['ratings'] as List).map(
              (e) => ClientRating(
            tripId: e['tripId'] as String?,
            rating: e['rating'] as int?,
            comment: e['comment'] as String?,
            createdAt:
            e['createdAt'] == null ? null : DateTime.parse(e['createdAt']),
          ),
        ),
      );
    }

    return ClientAllRatingModel(
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