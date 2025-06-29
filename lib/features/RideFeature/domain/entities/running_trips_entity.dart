// class RunningTripsEntity {
//   final String id;
//   final String from;
//   final String to;
//   final String categoryPicture;
//   final String categoryNameEn;
//   final String categoryNameAr;
//   final String carPicture;
//   final String address;
//   final DateTime createdAt;
//   final int price;
//   final String status;
//   final String currencyEn;
//   final String currencyAr;
//   final String? rating;
//   final String car;
//   final String gender;
//   final String clientFirstName;
//   final String clientLastName;
//   final String clientGender;
//
//   RunningTripsEntity({
//     required this.id,
//     required this.from,
//     required this.to,
//     required this.categoryPicture,
//     required this.categoryNameEn,
//     required this.categoryNameAr,
//     required this.carPicture,
//     required this.address,
//     required this.createdAt,
//     required this.price,
//     required this.status,
//     required this.currencyEn,
//     required this.currencyAr,
//     this.rating,
//     required this.car,
//     required this.gender,
//     required this.clientFirstName,
//     required this.clientLastName,
//     required this.clientGender,
//   });
// }

class RunningTripsEntity {
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

  RunningTripsEntity({
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
  });
}