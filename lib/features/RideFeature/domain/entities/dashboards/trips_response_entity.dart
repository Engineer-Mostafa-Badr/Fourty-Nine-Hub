import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_entity.dart';

class TripsResponseEntity {
  final bool status;
  final List<TripEntity> trips;
  // final Pagination pagination;

  TripsResponseEntity({
    required this.status,
    required this.trips,
    // required this.pagination,
  });
}

// class Pagination {
//   final int countItem;
//   final int pageCount;

//   Pagination({required this.countItem, required this.pageCount});
// }
