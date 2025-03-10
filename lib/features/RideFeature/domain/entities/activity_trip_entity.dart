import 'package:fourtyninehub/features/RideFeature/domain/entities/current_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/past_trip_entity.dart';

class ActivityTripEntity {
  final List<CurrentTripEntity>? currentTrips;
  final List<PastTripEntity>? pastTrips;

  ActivityTripEntity({
    this.currentTrips,
    this.pastTrips,
  });
}