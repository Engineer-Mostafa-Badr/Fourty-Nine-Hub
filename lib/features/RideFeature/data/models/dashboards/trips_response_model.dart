import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/trip_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trips_response_entity.dart';


class TripsResponseModel extends TripsResponseEntity {
  TripsResponseModel({required super.status, required TripDataModel super.data});

   factory TripsResponseModel.fromJson(Map<String, dynamic> json) {
    return TripsResponseModel(
      status: json['status'],
      data: TripDataModel.fromJson(json['data']),
    );
  }
}

class TripDataModel extends TripDataEntity {
  TripDataModel({required List<TripModel> trips})
      : super(trips: trips);

  factory TripDataModel.fromJson(Map<String, dynamic> json) {
    return TripDataModel(
      trips: List<TripModel>.from(json['trips'].map((x) => TripModel.fromJson(x))),
      // pagination: PaginationModel.fromJson(json['pagination']),
    );
  }
}
