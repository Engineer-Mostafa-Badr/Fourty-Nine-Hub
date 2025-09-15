import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_rating_entity.dart';

class DriverRatingModel extends DriverRatingEntity{
  /*
  {
                "tripId": "688a764f143e1a7ef09ee64a",
                "rating": 4,
                "comment": "Yyyyyy",
                "clientFirstName": "Mon",
                "createdAt": "2025-07-30T21:30:48.796Z"
            },
   */

  DriverRatingModel({
    required super.tripId,
    required super.rating,
    required super.comment,
    required super.clientFirstName,
    required super.createdAt,
  });

  factory DriverRatingModel.fromJson(Map<String, dynamic> json) {
    return DriverRatingModel(
      tripId: json['tripId'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      clientFirstName: json['clientFirstName'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }
}