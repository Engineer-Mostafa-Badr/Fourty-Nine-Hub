class HistoryTripsEntity {
  final String? tripId;
  final String? tripStatus;
  final bool? isAutoAccept;
  final bool? isPremium;
  final double? price;
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
  });
}