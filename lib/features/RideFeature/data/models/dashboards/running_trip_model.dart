import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/trip_location_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';

class RunningTripModel extends RunningTripEntity {
  RunningTripModel({
    required super.tripId,
    required super.status,
    super.startLocation,
    super.targetLocation,
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
  });

  factory RunningTripModel.fromJson(Map<String, dynamic> json) {
    final tripDetails = json['tripDetails'] as Map<String, dynamic>? ?? {};
    final location = tripDetails['location'] as Map<String, dynamic>? ?? {};
    final subCategory = tripDetails['subCategory'] as Map<String, dynamic>? ?? {};
    final clientDetails = json['clientDetails'] as Map<String, dynamic>? ?? {};

    List<List<double>> parsedPolyline = [];

    if (location['polyline'] != null) {
      if (location['polyline'] is String) {
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decoded = polylinePoints.decodePolyline(location['polyline']);
        parsedPolyline = decoded.map((e) => [e.longitude, e.latitude]).toList();
      } else if (location['polyline'] is List) {
        parsedPolyline = (location['polyline'] as List)
            .map((e) => (e as List).map((p) => (p as num).toDouble()).toList())
            .toList();
      }
    }

    return RunningTripModel(
      tripId: tripDetails['id'] ?? 0,
      duration: tripDetails['duration'] ?? 0,
      distance: tripDetails['distance'] ?? 0,
      status: tripDetails['status'] ?? '',
      startLocation:location['start'] == null ? null : TripLocationModel.fromJson(location['start']),
      targetLocation: location['target'] == null ? null : TripLocationModel.fromJson(location['target']),
      wayPointOne:location['wayPointOne'] == null ? null : TripLocationModel.fromJson(location['wayPointOne']),
      wayPointTwo: location['wayPointTwo'] == null ? null : TripLocationModel.fromJson(location['wayPointTwo']),
      polyline: parsedPolyline,
      subCategoryId: subCategory['id'] ?? 0,
      subCategoryNameAr: subCategory['nameAr'] ?? '',
      subCategoryNameEn: subCategory['nameEn'] ?? '',
      subCategoryPicture: subCategory['picture'] ?? '',
      clientName: clientDetails['firstName'] ?? '',
      clientGender: clientDetails['gender'] ?? '',
      clientPicture: clientDetails['profilePicture'] ?? '',
    );
  }

}