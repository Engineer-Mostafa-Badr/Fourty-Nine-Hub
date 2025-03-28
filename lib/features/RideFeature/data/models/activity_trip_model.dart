import 'package:fourtyninehub/features/RideFeature/data/models/current_trips_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/past_trip_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/activity_trip_entity.dart';

class ActivityTripModel extends ActivityTripEntity {
  ActivityTripModel({
    required super.currentTrips,
    required super.pastTrips,
  });

  factory ActivityTripModel.fromJson(Map<String, dynamic> json) {
    return ActivityTripModel(
      currentTrips: json['currentTrips'] != null ? (json['currentTrips'] as List).map((e) => CurrentTripModel.fromJson(e)).toList() : null,
      pastTrips: json['pastTrips'] != null ? (json['pastTrips'] as List).map((e) => PastTripModel.fromJson(e)).toList() : null,
    );
  }
}