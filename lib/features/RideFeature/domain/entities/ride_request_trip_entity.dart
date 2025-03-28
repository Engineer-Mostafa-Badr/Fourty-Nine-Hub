class RideRequestTripEntity {
  final String? id;
  final String? userId;
  final String? riderId;
  final String? subCategoryId;
  final String? carTypeId;
  final String? from;
  final String? to;
  final List<double>? startCoordinates;
  final List<double>? targetCoordinates;
  final double? distance;
  final int? duration;
  final int? passengers;
  final double? price;
  final String? paymentMethod;
  final String? status;
  final bool? autoAccept;
  final bool? isPremium;
  final bool? isUserGetCashback;
  final bool? isRiderGetCashback;
  final bool? freeTripForDriver;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? expireAt;
  final double? rating;

  RideRequestTripEntity({required this.id, required this.userId, required this.riderId, required this.subCategoryId, required this.carTypeId, required this.from, required this.to, required this.startCoordinates, required this.targetCoordinates, required this.distance, required this.duration, required this.passengers, required this.price, required this.paymentMethod, required this.status, required this.autoAccept, required this.isPremium, required this.isUserGetCashback, required this.isRiderGetCashback, required this.freeTripForDriver, required this.createdAt, required this.updatedAt, required this.expireAt, required this.rating});
}