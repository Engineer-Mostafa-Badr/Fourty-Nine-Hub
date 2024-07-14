import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';

import 'trip_request_entity.dart';

class TripAndRequestEntity {
  final TripEntity trip;
  final List<TripRequestEntity> requests;
  TripAndRequestEntity({
    required this.requests,
    required this.trip
  });
}
