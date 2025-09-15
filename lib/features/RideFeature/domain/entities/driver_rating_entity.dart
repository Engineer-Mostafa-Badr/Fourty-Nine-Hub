class DriverRatingEntity {
  /*
  {
                "tripId": "688a764f143e1a7ef09ee64a",
                "rating": 4,
                "comment": "Yyyyyy",
                "clientFirstName": "Mon",
                "createdAt": "2025-07-30T21:30:48.796Z"
            },
   */

  final String tripId;
  final num? rating;
  final String comment;
  final String clientFirstName;
  final DateTime createdAt;

  DriverRatingEntity({
    required this.tripId,
    required this.rating,
    required this.comment,
    required this.clientFirstName,
    required this.createdAt,
  });
}