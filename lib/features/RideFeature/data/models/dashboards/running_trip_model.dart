import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/trip_location_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';

class RunningTripModel extends RunningTripEntity {
  RunningTripModel({
    required super.tripId,
    required super.status,
    required super.from,
    required super.to,
    required super.startCoordinates,
    required super.targetCoordinates,
    required super.wayPointOneTitle,
    required super.wayPointTwoTitle,
    required super.clientRaiting,
    super.wayPointOne,
    super.wayPointTwo,
    required super.polyline,
    required super.subCategoryId,
    required super.subCategoryNameAr,
    required super.subCategoryNameEn,
    required super.subCategoryPicture,
    required super.clientName,
    required super.clientGender,
    required super.clientPicture,
    required super.duration,
    required super.distance,
    required super.clientId,
    required super.driverId,
    required super.price,
  });

  factory RunningTripModel.fromJson(Map<String, dynamic> json) {
    final tripDetails = json['tripDetails'] as Map<String, dynamic>? ?? {};
    final location = tripDetails['location'] as Map<String, dynamic>? ?? {};
    final subCategory = tripDetails['subCategory'] as Map<String, dynamic>? ?? {};
    final clientDetails = json['clientDetails'] as Map<String, dynamic>? ?? {};

    List<List<double>> parsedPolyline = [];

    if (location['polyline'] != null) {
      if (location['polyline'] is String) {
        // Decode the encoded polyline string
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decoded = polylinePoints.decodePolyline(location['polyline']);
        parsedPolyline = decoded.map((e) => [e.latitude, e.longitude]).toList();
      } else if (location['polyline'] is List) {
        // Use the list directly
        parsedPolyline = (location['polyline'] as List)
            .map((e) => (e as List).map((p) => (p as num).toDouble()).toList())
            .toList();
      }
    }

    return RunningTripModel(
      tripId: tripDetails['id'] ?? 0,
      driverId: tripDetails['driverId'] ?? '',
      duration: tripDetails['duration'] ?? 0,
      distance: tripDetails['distance'] ?? 0,
      status: tripDetails['status'] ?? '',
      price: tripDetails['price'] ?? 0,

      from: location['start']?['title'],
      to: location['target']?['title'],
      wayPointOneTitle: location['wayPointOne']?['title'],
      wayPointTwoTitle: location['wayPointTwo']?['title'],
      startCoordinates: [location["start"]?['latitude'] ?? 0.0, location["start"]?['longitude'] ?? 0.0],
      targetCoordinates: [location["target"]?['latitude'] ?? 0.0, location["target"]?['longitude'] ?? 0.0],
      wayPointOne: [location["wayPointOne"]?['latitude'] ?? 0.0, location["wayPointOne"]?['longitude'] ?? 0.0],
      wayPointTwo: [location["wayPointTwo"]?['latitude'] ?? 0.0, location["wayPointTwo"]?['longitude'] ?? 0.0],
      polyline: parsedPolyline,

      subCategoryId: subCategory['id'] ?? 0,
      subCategoryNameAr: subCategory['nameAr'] ?? '',
      subCategoryNameEn: subCategory['nameEn'] ?? '',
      subCategoryPicture: subCategory['picture'] ?? '',
      clientName: clientDetails['firstName'] ?? '',
      clientId: clientDetails['id'] ?? '',
      clientGender: clientDetails['gender'] ?? '',
      clientPicture: clientDetails['profilePicture'] ?? '',
      clientRaiting: clientDetails['rating']!=null?clientDetails['rating']['average'] ?? 0:0,
    );
  }

}