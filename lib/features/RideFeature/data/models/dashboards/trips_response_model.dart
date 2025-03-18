import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/trip_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trips_response_entity.dart';

class TripsResponseModel extends TripsResponseEntity {
  TripsResponseModel({
    required super.status,
    required List<TripModel> super.trips,
    // required PaginationModel super.pagination,
  });

  factory TripsResponseModel.fromJson(Map<String, dynamic> json) {
    return TripsResponseModel(
      status: json['status'],
      trips: (json['data']['trips'] as List)
          .map((trip) => TripModel.fromJson(trip))
          .toList(),
      // pagination: PaginationModel.fromJson(json['pagination']),
    );
  }
}

// class PaginationModel extends Pagination {
//   PaginationModel({required super.countItem, required super.pageCount});

//   factory PaginationModel.fromJson(Map<String, dynamic> json) {
//     return PaginationModel(
//       countItem:10, //json['countItem'],
//       pageCount:1 //json['pageCount'],
//     );
//   }
// }
