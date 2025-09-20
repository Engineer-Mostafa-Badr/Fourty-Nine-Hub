import '../driver_rank_enum.dart';

class DriverDetailsEntity {
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

  final String id;
  final String firstName;
  final String lastName;
   bool isAccountVerified;
  final String gender;
  final DateTime registeredAt;
  final String? pictureUrl;
  final num totalCompletedTrips;
  final num totalKM;
   DriverRank currentRank;
  final DriverRank nextRank;
  final int tripsToNextRank;
  final num? rating;
  final int totalRatings;

  DriverDetailsEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.isAccountVerified,
    required this.gender,
    required this.registeredAt,
    required this.pictureUrl,
    required this.totalCompletedTrips,
    required this.totalKM,
    required this.currentRank,
    required this.nextRank,
    required this.tripsToNextRank,
    required this.rating,
    required this.totalRatings,
  });
}