import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_location_entity.dart';

class RunningTripEntity {
  final String tripId;
  final String driverId;
  String? status;
  final TripLocationEntity? startLocation;
  final TripLocationEntity? targetLocation;
  final TripLocationEntity? wayPointOne;
  final TripLocationEntity? wayPointTwo;
  final List<List<double>> polyline;
  final String subCategoryId;
  final String subCategoryNameAr;
  final String subCategoryNameEn;
  final String subCategoryPicture;
  final String clientId;
  final String clientName;
  final String clientGender;
  final String clientPicture;
  final int distance;
  final int duration;

  RunningTripEntity({required this.tripId,required this.driverId,required this.clientId,required this.distance,required this.duration, this.status, this.startLocation, this.targetLocation, this.wayPointOne, this.wayPointTwo, required this.polyline, required this.subCategoryId, required this.subCategoryNameAr, required this.subCategoryNameEn, required this.subCategoryPicture, required this.clientName, required this.clientGender, required this.clientPicture});

}