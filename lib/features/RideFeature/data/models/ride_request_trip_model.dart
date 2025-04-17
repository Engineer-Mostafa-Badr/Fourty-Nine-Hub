import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_request_trip_entity.dart';

class RideRequestTripModel extends RideRequestTripEntity {
  RideRequestTripModel({
    required super.id,
    required super.userId,
    required super.riderId,
    required super.subCategoryId,
    required super.carTypeId,
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
    required super.isUserGetCashback,
    required super.isRiderGetCashback,
    required super.freeTripForDriver,
    required super.createdAt,
    required super.updatedAt,
    required super.expireAt,
    required super.rating,
    required super.driverId,
    required super.driverFirstName,
    required super.driverIsArrivingIn,
    required super.driverPhoneNumber,
    required super.driverProfilePicture,
    required super.driverRating,
    required super.driverRatingCount,
    required super.driverUserId,
    required super.vehicleBrand,
    required super.vehicleModel,
    required super.vehicleColor,
    required super.vehiclePicture,
    required super.vehiclePlateNumber,
    required super.polyline,
    required super.wayPointOne,
    required super.wayPointTwo,
    required super.wayPointOneTitle,
    required super.wayPointTwoTitle,
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

    return RideRequestTripModel(
      id: json['_id'] ?? '', // Handle null by providing an empty string
      // userId: json['userId'] ?? '',
      userId: '',
      riderId: json['riderId'] ?? '',
      // subCategoryId: json['subCategoryId'] ?? '',
      subCategoryId: '',
      carTypeId: json['carTypeId'] ?? '',
      from: json['fromTitle'] ?? 'Unknown',
      to: json['toTitle'] ?? 'Unknown',
      wayPointOneTitle: json['wayPointOneTitle'] ?? 'Unknown',
      wayPointTwoTitle: json['wayPointTwoTitle'] ?? 'Unknown',
      startCoordinates: (json['startLocation']?['coordinates'] as List<dynamic>?)
          ?.map((coord) => (coord as num?)?.toDouble() ?? 0.0)
          .toList() ??
          [0.0, 0.0], // Default empty coordinates
      targetCoordinates: (json['targetLocation']?['coordinates'] as List<dynamic>?)
          ?.map((coord) => (coord as num?)?.toDouble() ?? 0.0)
          .toList() ??
          [0.0, 0.0], // Default empty coordinates
      wayPointOne: (json['wayPointOne']?['coordinates'] as List<dynamic>?)
          ?.map((coord) => (coord as num?)?.toDouble() ?? 0.0)
          .toList() ??
          [0.0, 0.0],
      wayPointTwo: (json['wayPointTwo']?['coordinates'] as List<dynamic>?)
          ?.map((coord) => (coord as num?)?.toDouble() ?? 0.0)
          .toList() ??
          [0.0, 0.0],
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0, // Default to 0.0
      duration: json['duration'] ?? 0, // Default to 0
      passengers: json['passengers'] ?? 1, // Default to 1 passenger
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Default to 0.0
      lowestFare: (json['lowestFare'] as num?)?.toDouble() ?? 0.0, // Default to 0.0
      highestFare: (json['highestFare'] as num?)?.toDouble() ?? 0.0, // Default to 0.0
      paymentMethod: json['paymentMethod'] ?? 'Cash', // Default payment method
      status: json['status'] ?? 'Pending', // Default status
      autoAccept: json['autoAccept'] ?? false, // Default to false
      isPremium: json['isPremium'] ?? false, // Default to false
      isUserGetCashback: json['isUserGetCashback'] ?? false, // Default to false
      isRiderGetCashback: json['isRiderGetCashback'] ?? false, // Default to false
      freeTripForDriver: json['freeTripForDriver'] ?? false, // Default to false
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) ?? DateTime.now() : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now() : DateTime.now(),
      expireAt: json['expireAt'] != null ? DateTime.tryParse(json['expireAt']) ?? DateTime.now() : DateTime.now(),
      rating: (json['rate'] as num?)?.toDouble() ?? 0.0, // Default rating to 0.0
      driverId: json['driverDetails']?['driverId'] ?? '',
      driverUserId: json['driverDetails']?['driverUserId'] ?? '',
      driverFirstName: json['driverDetails']?['firstName'] ?? '',
      driverIsArrivingIn: (json['driverIsArrivingIn'] as num?)?.toDouble() ?? 0,
      driverPhoneNumber: json['driverDetails']?['phoneNumber'] ?? '',
      driverProfilePicture: json['driverDetails']?['profilePictureUrl'],
      driverRating: (json['driverDetails']?['rating']?['averageRating'] as num?)?.toDouble() ?? 0.0,
      driverRatingCount: (json['driverDetails']?['rating']?['totalRatings'] as num?)?.toInt() ?? 0,
      vehicleBrand: json['vehicleDetails']?['brand'] ?? '',
      vehicleModel: json['vehicleModel']?['model'] ?? '',
      vehicleColor: json['vehicleDetails']?['color'] ?? '',
      vehiclePlateNumber: json['vehicleDetails']?['plateInfo'] ?? '',
      vehiclePicture: json['vehicleDetails']?['carPictureUrl'],
      // polyline: json['polyline'] != null
      //     ? (json['polyline'] as List)
      //     .map((e) =>
      //     (e as List)
      //         .map((p) => (p as num).toDouble())
      //         .toList())
      //     .toList()
      //     : [],
      polyline: parsedPolyline,
    );
  }
}
