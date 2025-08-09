import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_request_trip_entity.dart';

class RideRequestTripModel extends RideRequestTripEntity {
  RideRequestTripModel({
    required super.id,
    required super.userId,
    required super.subCategoryId,
    required super.from,
    required super.to,
    required super.startCoordinates,
    required super.targetCoordinates,
    required super.distance,
    required super.duration,
    required super.passengers,
    required super.price,
    required super.lowestFare,
    required super.highestFare,
    required super.paymentMethod,
    required super.status,
    required super.autoAccept,
    required super.isPremium,
    required super.createdAt,
    required super.rating,
    required super.driverId,
    required super.driverFirstName,
    required super.driverIsArrivingIn,
    required super.tripStartedAt,
    required super.driverPhoneNumber,
    required super.driverProfilePicture,
    required super.driverRating,
    required super.driverRatingCount,
    required super.driverUserId,
    required super.vehicleBrandAr,
    required super.vehicleBrandEn,
    required super.vehicleModelAr,
    required super.vehicleModelEn,
    required super.vehicleColor,
    required super.vehiclePicture,
    required super.vehiclePlateNumber,
    required super.polyline,
    required super.wayPointOne,
    required super.wayPointTwo,
    required super.wayPointOneTitle,
    required super.wayPointTwoTitle,
    required super.driverPolyline,
    required super.driverStartLat,
    required super.driverStartLng,
    required super.driverTargetLat,
    required super.driverTargetLng,
    required super.otp,
  });

  factory RideRequestTripModel.fromJson(Map<String, dynamic> json) {

    List<List<double>> parsedPolyline = [];

    if (json['polyline'] != null) {
      if (json['polyline'] is String) {
        // Decode the encoded polyline string
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decoded = polylinePoints.decodePolyline(json['polyline']);
        parsedPolyline = decoded.map((e) => [e.latitude, e.longitude]).toList();
      } else if (json['polyline'] is List) {
        // Use the list directly
        parsedPolyline = (json['polyline'] as List)
            .map((e) => (e as List).map((p) => (p as num).toDouble()).toList())
            .toList();
      }
    }

    List<List<double>> driverPolyline = [];

    if (json['driverLocation']?['polyline'] != null) {
      if (json['driverLocation']?['polyline'] is String) {
        // Decode the encoded polyline string
        PolylinePoints driverPolylinePoints = PolylinePoints();
        List<PointLatLng> decoded = driverPolylinePoints.decodePolyline(json['driverLocation']?['polyline']);
        driverPolyline = decoded.map((e) => [e.latitude, e.longitude]).toList();
      } else if (json['driverLocation']?['polyline'] is List) {
        // Use the list directly
        driverPolyline = (json['driverLocation']?['polyline'] as List)
            .map((e) => (e as List).map((p) => (p as num).toDouble()).toList())
            .toList();
      }
    }

    return RideRequestTripModel(
      id: json['tripId'] ?? '',
      userId: json['userId'] ?? '',
      subCategoryId: json['subcategoryId'] ?? '',
      from: json['fromTitle'],
      to: json['toTitle'],
      wayPointOneTitle: json['waypointOneTitle'],
      wayPointTwoTitle: json['waypointTwoTitle'],
      startCoordinates: (json['startLocation']?['coordinates'] as List<dynamic>?)
          ?.map((coord) => (coord as num?)?.toDouble() ?? 0.0)
          .toList() ??
          [0.0, 0.0], // Default empty coordinates
      targetCoordinates: (json['targetLocation']?['coordinates'] as List<dynamic>?)
          ?.map((coord) => (coord as num?)?.toDouble() ?? 0.0)
          .toList() ??
          [0.0, 0.0], // Default empty coordinates
      wayPointOne: (json['waypointOne']?['coordinates'] as List<dynamic>?)
          ?.map((coord) => (coord as num?)?.toDouble() ?? 0.0)
          .toList() ??
          [0.0, 0.0],
      wayPointTwo: (json['waypointTwo']?['coordinates'] as List<dynamic>?)
          ?.map((coord) => (coord as num?)?.toDouble() ?? 0.0)
          .toList() ??
          [0.0, 0.0],
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0, // Default to 0.0
      duration: (json['duration'] as num?)?.toInt() ?? 0, // Default to 0
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Default to 0.0
      otp: json['OTP'],
      lowestFare: (json['lowestFare'] as num?)?.toDouble() ?? 0.0, // Default to 0.0
      highestFare: (json['highestFare'] as num?)?.toDouble() ?? 0.0, // Default to 0.0
      paymentMethod: json['paymentMethod'] ?? 'cash', // Default payment method
      status: json['status'] ?? 'canceled', // Default status
      autoAccept: json['autoAccept'] ?? false, // Default to false
      isPremium: json['isPremium'] ?? false, // Default to false
      passengers: json['passengers'] ?? 2, // Default to 0
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) ?? DateTime.now() : DateTime.now(),
      rating: (json['rate'] as num?)?.toDouble() ?? 0.0, // Default rating to 0.0
      driverId: json['driverDetails']?['driverId'],
      driverUserId: json['driverDetails']?['driverUserId'],
      driverFirstName: json['driverDetails']?['driverFirstName'],
      driverIsArrivingIn: (json['driverDetails']?['driverIsArrivingIn']) != null ? DateTime.parse(json['driverDetails']!['driverIsArrivingIn']).toLocal() : null,
      driverPhoneNumber: json['driverDetails']?['driverPhoneNumber'] ?? '',
      driverProfilePicture: json['driverDetails']?['driverProfilePictureUrl'],
      driverRating: (json['driverDetails']?['rating']?['averageRating'] as num?)?.toDouble() ?? 0.0,
      driverRatingCount: (json['driverDetails']?['rating']?['totalRating'] as num?)?.toInt() ?? 0,
      vehicleBrandAr: json['driverDetails']?['vehicleDetails']?['brandAr'],
      vehicleBrandEn: json['driverDetails']?['vehicleDetails']?['brandEn'],
      vehicleModelAr: json['driverDetails']?['vehicleDetails']?['modelAr'],
      vehicleModelEn: json['driverDetails']?['vehicleDetails']?['modelEn'],
      vehicleColor: json['driverDetails']?['vehicleDetails']?['color'],
      vehiclePlateNumber: json['driverDetails']?['vehicleDetails']?['plateInfo'],
      vehiclePicture: (json['driverDetails']?['vehicleDetails']?['carPictureUrl'] as List<dynamic>?)?[0],
      polyline: parsedPolyline,
      driverPolyline: driverPolyline,
      driverStartLat: json['driverLocation']?['start']?['latitude'] ?? 0.0,
      driverStartLng: json['driverLocation']?['start']?['longitude'] ?? 0.0,
      driverTargetLat: json['driverLocation']?['target']?['latitude'] ?? 0.0,
      driverTargetLng: json['driverLocation']?['target']?['longitude'] ?? 0.0,
      tripStartedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt']).toLocal() : null,
    );
  }
}
