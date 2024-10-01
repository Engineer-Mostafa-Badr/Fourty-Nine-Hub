import 'closer_driver.dart';
import 'trip.dart';

class SuccessRequestTripModel {
  Trip? trip;
  List<CloserDriver>? closerDrivers;

  SuccessRequestTripModel({this.trip, this.closerDrivers});

  factory SuccessRequestTripModel.fromJson(Map<String, dynamic> json) {
    return SuccessRequestTripModel(
      trip: json['trip'] == null
          ? null
          : Trip.fromJson(json['trip'] as Map<String, dynamic>),
      closerDrivers: (json['closerDrivers'] as List<dynamic>?)
          ?.map((e) => CloserDriver.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'trip': trip?.toJson(),
        'closerDrivers': closerDrivers?.map((e) => e.toJson()).toList(),
      };
}
