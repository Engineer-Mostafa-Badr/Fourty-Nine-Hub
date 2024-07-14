import 'package:fourtyninehub/features/requests_history/data/models/trip_model.dart';
import 'package:fourtyninehub/features/ride/trip_details/data/models/trip_request_model.dart';

import '../../domain/entities/trip_and_request_entity.dart';

class TripAndRequestModel extends TripAndRequestEntity {
  TripAndRequestModel({required super.requests, required super.trip});
  factory TripAndRequestModel.fromJson(Map<String, dynamic> json) {
    return TripAndRequestModel(
        trip: TripModel.fromJson(json['trip']),
        requests: (json['requests'] as List)
            .map((e) => TripRequestModel.fromJson(e))
            .toList());
  }
}
