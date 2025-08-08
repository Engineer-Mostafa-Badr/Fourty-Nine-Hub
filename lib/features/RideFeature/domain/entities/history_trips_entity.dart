class HistoryTripsEntity {
  final String? tripId;
  final String? tripStatus;
  final bool? isAutoAccept;
  final bool? isPremium;
  final double? price;
  final String? paymentMethod;
  final String? wayPointOneAddressTitle;
  final double? wayPointOneLat;
  final double? wayPointOneLng;
  final String? wayPointTwoAddressTitle;
  final double? wayPointTwoLat;
  final double? wayPointTwoLng;
  final bool isDriverVerified;
  final bool verifiedBadge;
  final List<List<double>> polyline;
  final DateTime? createdAt;
  final String? startLocationAddressTitle;
  final double? startLocationLat;
  final double? startLocationLng;
  final String? targetLocationAddressTitle;
  final double? targetLocationLat;
  final double? targetLocationLng;
  final String? subcategoryId;
  final String? subCategoryNameAr;
  final String? subCategoryNameEn;
  final String? subCategoryPicture;
  final String? driverId;
  final String? driverUserId;
  final String? driverFirstName;
  final String? driverProfileUrl;
  final double? driverAverageRating;
  final int? driverRatingCount;
  final String? recordUrl;

  HistoryTripsEntity({
    required this.tripId,
    required this.tripStatus,
    required this.isAutoAccept,
    required this.isPremium,
    required this.price,
    required this.createdAt,
    required this.startLocationAddressTitle,
    required this.startLocationLat,
    required this.startLocationLng,
    required this.targetLocationAddressTitle,
    required this.targetLocationLat,
    required this.targetLocationLng,
    required this.subcategoryId,
    required this.wayPointOneAddressTitle,
    required this.wayPointOneLat,
    required this.wayPointOneLng,
    required this.wayPointTwoAddressTitle,
    required this.wayPointTwoLat,
    required this.wayPointTwoLng,
    required this.isDriverVerified,
    required this.verifiedBadge,
    required this.paymentMethod,
    required this.subCategoryNameAr,
    required this.subCategoryNameEn,
    required this.subCategoryPicture,
    required this.driverId,
    required this.driverUserId,
    required this.driverFirstName,
    required this.driverProfileUrl,
    required this.driverAverageRating,
    required this.driverRatingCount,
    required this.recordUrl,
    required this.polyline
  });
}