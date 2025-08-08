class RideOfferEntity {
  final String offerId;
  final String driverId;
  final String tripId;
  final String? driverName;
  final String? driverImage;
  final String? carModel;
  final int? price;
  final double? distance;
  final double? duration;
  final double? rating;
  final int? ratingCount;
  final int? tripsCount;
  bool isExpired = false;
  final bool isComfort;
  final bool isNonSmoking;

  RideOfferEntity({required this.offerId, required this.isComfort, required this.isNonSmoking, required this.driverId, required this.tripId, required this.driverName, required this.driverImage, required this.carModel, required this.price, required this.distance, required this.duration, required this.rating, required this.ratingCount, required this.tripsCount});
}