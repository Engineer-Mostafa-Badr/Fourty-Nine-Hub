// import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';
//
// class CompletedTripsModel extends CompletedTripsEntity {
//   CompletedTripsModel({
//     required super.id,
//     required super.to,
//     required super.from,
//     required super.categoryPicture,
//     required super.categoryNameEn,
//     required super.categoryNameAr,
//     required super.carPicture,
//     required super.address,
//     required super.createdAt,
//     required super.price,
//     required super.status,
//     required super.currencyEn,
//     required super.currencyAr,
//     required super.rating,
//     required super.car,
//     required super.gender,
//     required super.clientFirstName,
//     required super.clientLastName,
//     required super.clientGender,
//   });
//
//   factory CompletedTripsModel.fromJson(Map<String, dynamic> json) {
//     return CompletedTripsModel(
//       id: json['id'] ?? '',
//       from: json['from'] ?? '',
//       to: json['to'] ?? '',
//       categoryPicture: json['categoryPicture'] ?? '',
//       categoryNameEn: json['categoryNameEn'] ?? '',
//       categoryNameAr: json['categoryNameAr'] ?? '',
//       carPicture: (json['carPicture'] as List<dynamic>?)?[0] ?? '',
//       address: json['address'] ?? '',
//       createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
//       price: json['price'] ?? 0,
//       status: json['status'] ?? '',
//       currencyEn: json['currency']?['currencyEn'] ?? 'Unknown',
//       currencyAr: json['currency']?['currencyAr'] ?? 'Unknown',
//       rating: json['rating']?.toString(),
//       car: json['car'] ?? 'Unknown',
//       gender: json['gender'] ?? 'Unknown',
//       clientFirstName: json['client']['firstName'] ?? 'Unknown',
//       clientLastName: json['client']['lastName'] ?? 'Unknown',
//       clientGender: json['client']['gender'] ?? 'male',
//     );
//   }
// }


import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';

class CompletedTripsModel extends CompletedTripsEntity {
  CompletedTripsModel({
    required super.tripId,
    required super.tripStatus,
    required super.isAutoAccept,
    required super.isPremium,
    required super.price,
    required super.createdAt,
    required super.paymentMethod,
    required super.wayPointOneAddressTitle,
    required super.wayPointOneLat,
    required super.wayPointOneLng,
    required super.wayPointTwoAddressTitle,
    required super.wayPointTwoLat,
    required super.wayPointTwoLng,
    required super.isDriverVerified,
    required super.verifiedBadge,
    required super.polyline,
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
  });

  factory CompletedTripsModel.fromJson(Map<String, dynamic> json) {
    List<List<double>> parsedPolyline = [];

    if (json['tripDetails']? ['location']?['polyline'] != null) {
      if (json ['tripDetails']? ['location']?['polyline'] is String) {
        // Decode the encoded polyline string
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decoded = polylinePoints.decodePolyline(json ['tripDetails']? ['location']?['polyline']);
        parsedPolyline = decoded.map((e) => [e.latitude, e.longitude]).toList();
      } else if (json ['tripDetails']? ['location']?['polyline'] is List) {
        // Use the list directly
        parsedPolyline = (json ['tripDetails']? ['location']?['polyline'] as List)
            .map((e) => (e as List).map((p) => (p as num).toDouble()).toList())
            .toList();
      }
    }
    return CompletedTripsModel(
      tripId: json['tripDetails']?['id'],
      tripStatus: json['tripDetails']?['status'],
      isAutoAccept: json['tripDetails']?['isAutoAccept'] ?? false,
      isPremium: json['tripDetails']?['isPremium'] ?? false,
      price: json['tripDetails']?['price']?.toDouble() ?? 0.0,
      paymentMethod: json['tripDetails']?['paymentMethod'],
      wayPointOneAddressTitle: json ['tripDetails']? ['location']?['waypointOne']?['addressTitle'],
      wayPointOneLat:  (json['tripDetails']?['location']?['waypointOne']?['coordinates'] != null && (json ['tripDetails']? ['location']?['waypointOne']?['coordinates'] as List).isNotEmpty) ? (json ['tripDetails']? ['location']?['waypointOne']?['coordinates']?[0]) : null,
      wayPointOneLng: (json['tripDetails']?['location']?['waypointOne']?['coordinates'] != null && (json ['tripDetails']? ['location']?['waypointOne']?['coordinates'] as List).isNotEmpty) ? (json ['tripDetails']? ['location']?['waypointOne']?['coordinates']?[1]) : null,
      wayPointTwoAddressTitle: json ['tripDetails']? ['location']?['waypointTwo']?['addressTitle'],
      wayPointTwoLat: (json['tripDetails']?['location']?['waypointTwo']?['coordinates'] != null && (json ['tripDetails']? ['location']?['waypointTwo']?['coordinates'] as List).isNotEmpty) ? (json ['tripDetails']? ['location']?['waypointTwo']?['coordinates']?[0]) : null,
      wayPointTwoLng: (json['tripDetails']?['location']?['waypointTwo']?['coordinates'] != null && (json ['tripDetails']? ['location']?['waypointTwo']?['coordinates'] as List).isNotEmpty) ? (json ['tripDetails']? ['location']?['waypointTwo']?['coordinates']?[1]) : null,
      isDriverVerified: json['driverDetails']?['userId']?['isAccountVerified'] ?? false,
      driverUserId: json['driverDetails']?['userId']?['_id'],
      polyline: parsedPolyline,
      verifiedBadge: json['driverDetails']?['verifiedBadge'] ?? false,
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
      driverFirstName: json['driverDetails']?['firstName'],
      driverProfileUrl: json['driverDetails']?['pictureUrl'],
      driverAverageRating: json['driverDetails']?['rating']?['averageRating']?.toDouble(),
      driverRatingCount: json['driverDetails']?['rating']?['ratingCount']?.toInt(),
    );
  }
}