import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_location_entity.dart';

class RunningTripEntity {
  final String tripId;
  final String driverId;
  String? status;
  String? tripStartTime;
  String? acceptedOfferAt;
  String? driverArrivalAt;
  String? driverIsArrivingIn;
  final String? from;
  final String? to;
  final String? wayPointOneTitle;
  final String? wayPointTwoTitle;
  final List<double>? startCoordinates;
  final List<double>? targetCoordinates;
  final List<double>? wayPointOne;
  final List<double>? wayPointTwo;
  final List<List<double>> polyline;
  final String subCategoryId;
  final String subCategoryNameAr;
  final String subCategoryNameEn;
  final String subCategoryPicture;
  final String clientId;
  final String clientName;
  final String clientGender;
  final String clientPicture;
  final num clientRaiting;
  final int distance;
  final int duration;
  final num price;

  RunningTripEntity({required this.tripId,required this.driverId,required this.clientRaiting,required this.price,required this.clientId,required this.distance,required this.duration, this.status,this.tripStartTime,this.acceptedOfferAt,this.driverArrivalAt,this.driverIsArrivingIn, this.from, this.to, this.wayPointOneTitle, this.wayPointTwoTitle, this.startCoordinates, this.targetCoordinates,  this.wayPointOne, this.wayPointTwo, required this.polyline, required this.subCategoryId, required this.subCategoryNameAr, required this.subCategoryNameEn, required this.subCategoryPicture, required this.clientName, required this.clientGender, required this.clientPicture});

}