import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trips_entity.dart';

class HistoryTripsModel extends HistoryTripsEntity {
  HistoryTripsModel({
    required super.tripId,
    required super.tripStatus,
    required super.isAutoAccept,
    required super.isPremium,
    required super.price,
    required super.createdAt,
    required super.startLocationAddressTitle,
    required super.startLocationLat,
    required super.startLocationLng,
    required super.targetLocationAddressTitle,
    required super.targetLocationLat,
    required super.targetLocationLng,
    required super.subcategoryId,
    required super.subCategoryNameEn,
    required super.subCategoryNameAr,
    required super.subCategoryPicture,
    required super.driverId,
    required super.driverUserId,
    required super.driverFirstName,
    required super.driverProfileUrl,
    required super.driverAverageRating,
    required super.driverRatingCount,
    required super.recordUrl,
  });

  factory HistoryTripsModel.fromJson(Map<String, dynamic> json) {
    return HistoryTripsModel(
      tripId: json['tripDetails']?['id'],
      tripStatus: json['tripDetails']?['status'],
      isAutoAccept: json['tripDetails']?['isAutoAccept'] ?? false,
      isPremium: json['tripDetails']?['isPremium'] ?? false,
      price: json['tripDetails']?['price']?.toDouble() ?? 0.0,
      recordUrl: json['tripDetails']?['recordUrl'],
      createdAt: DateTime.tryParse(json['tripDetails']?['createdAt']) ?? DateTime.now(),
      startLocationAddressTitle: json ['tripDetails']? ['location']?['start']?['addressTitle'],
      startLocationLat: json ['tripDetails']? ['location']?['start']?['coordinates']?['coordinates']?[0],
      startLocationLng: json ['tripDetails']? ['location']?['start']?['coordinates']?['coordinates']?[1],
      targetLocationAddressTitle: json ['tripDetails']? ['location']?['target']?['addressTitle'],
      targetLocationLat: json ['tripDetails']? ['location']?['target']?['coordinates']?['coordinates']?[0],
      targetLocationLng: json ['tripDetails']? ['location']?['target']?['coordinates']?['coordinates']?[1],
      subcategoryId: json ['tripDetails']?['subcategory']?['id'],
      subCategoryNameEn: json ['tripDetails']?['subcategory']?['nameEn'],
      subCategoryNameAr: json ['tripDetails']?['subcategory']?['nameAr'],
      subCategoryPicture: json ['tripDetails']?['subcategory']?['pictureUrl'],
      driverId: json['driverDetails']?['id'],
      driverUserId: json['driverDetails']?['userId'],
      driverFirstName: json['driverDetails']?['firstName'],
      driverProfileUrl: json['driverDetails']?['pictureUrl'],
      driverAverageRating: json['driverDetails']?['rating']?['averageRating']?.toDouble(),
      driverRatingCount: json['driverDetails']?['rating']?['ratingCount']?.toInt(),
    );
  }
}