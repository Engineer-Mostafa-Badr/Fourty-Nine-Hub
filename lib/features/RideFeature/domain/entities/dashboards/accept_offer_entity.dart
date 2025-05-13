class AcceptOfferEntity {
  final String tripId;
  final String waitingTime;
  final String locationToArriveFromTitle;
  final String? locationToArriveToTitle;
  final num locationToArriveStartLatitude;
  final num locationToArriveStartLongitude;
  final num locationToArriveTargetLatitude;
  final num locationToArriveTargetLongitude;
  final String? locationFromTitle;
  final String? locationToTitle;
  final num locationStartLatitude;
  final num locationStartLongitude;
  final num locationTargetLatitude;
  final num locationTargetLongitude;
  final String clientId;
  final String clientFirstName;
  final String clientLastName;
  final String profilePictureUrl;
  final num averageRating;
  final num totalRatings;

  AcceptOfferEntity({required this.tripId, required this.waitingTime, required this.locationToArriveFromTitle, required this.locationToArriveToTitle, required this.locationToArriveStartLatitude, required this.locationToArriveStartLongitude, required this.locationToArriveTargetLatitude, required this.locationToArriveTargetLongitude, required this.locationFromTitle, required this.locationToTitle, required this.locationStartLatitude, required this.locationStartLongitude, required this.locationTargetLatitude, required this.locationTargetLongitude, required this.clientId, required this.clientFirstName, required this.clientLastName, required this.profilePictureUrl, required this.averageRating, required this.totalRatings});
}