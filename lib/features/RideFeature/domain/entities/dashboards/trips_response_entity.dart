import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_entity.dart';


class TripsResponseEntity {
  final bool status;
  final TripDataEntity data;

  TripsResponseEntity({required this.status, required this.data});
}

class TripDataEntity {
  final List<TripEntity> trips;

  TripDataEntity({required this.trips});
}

