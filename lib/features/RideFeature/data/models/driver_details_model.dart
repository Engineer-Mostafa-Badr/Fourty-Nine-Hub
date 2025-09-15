import '../../domain/driver_rank_enum.dart';
import '../../domain/entities/driver_details_entity.dart';

class DriverDetailsModel extends DriverDetailsEntity {
  /*
  "id": "688a5617143e1a7ef09e8ddb",
  "firstName": "هاجر",
  "lastName": "احمد",
  "isAccountVerified": false,
  "gender": "female",
  "registeredAt": "2025-07-30T17:27:51.560Z",
  "pictureUrl": "https://d3j5umpuujp1ej.cloudfront.net/users/688a530b143e1a7ef09e8206/drivers/pictures.image/jpg/2da16c83-440f-4516-b7a7-24a991326c64.jpg",
  "totalCompletedTrips": 4,
  "totalKM": 197585,
  "rank": {
      "currentRank": "bronze",
      "nextRank": "silver",
      "tripsToNextRank": 96
  },
  "summary": {
      "rating": 3.75,
      "totalRatings": 4
  }
   */
  DriverDetailsModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.isAccountVerified,
    required super.gender,
    required super.registeredAt,
    required super.pictureUrl,
    required super.totalCompletedTrips,
    required super.totalKM,
    required super.currentRank,
    required super.nextRank,
    required super.tripsToNextRank,
    required super.rating,
    required super.totalRatings,
  });

  factory DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    return DriverDetailsModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      isAccountVerified: json['isAccountVerified'] ?? false,
      gender: json['gender'] ?? '',
      registeredAt: json['registeredAt'] != null ? DateTime.parse(json['registeredAt']) : DateTime.now(),
      pictureUrl: json['pictureUrl'],
      totalCompletedTrips: json['totalCompletedTrips'] ?? 0,
      totalKM: json['totalKM'] ?? 0,
      currentRank: DriverRank.fromString(json['rank']['currentRank'] ?? ''),
      nextRank: DriverRank.fromString(json['rank']['nextRank'] ?? ''),
      tripsToNextRank: json['rank']['tripsToNextRank'] ?? 0,
      rating: json['summary']['rating'],
      totalRatings: json['summary']['totalRatings'] ?? 0,
    );
  }
}