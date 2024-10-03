import 'start_location.dart';
import 'target_location.dart';

class GetTripInfoModel {
  StartLocation? startLocation;
  TargetLocation? targetLocation;
  String? fromTitle;
  String? toTitle;
  double? distance;
  double? duration;
  double? price;
  double? lowestFare;
  double? calculateB;
  String? subcategoryId;
  bool? comfort;

  GetTripInfoModel({
    this.startLocation,
    this.targetLocation,
    this.fromTitle,
    this.toTitle,
    this.distance,
    this.duration,
    this.price,
    this.lowestFare,
    this.calculateB,
    this.subcategoryId,
    this.comfort,
  });

  factory GetTripInfoModel.fromJson(Map<String, dynamic> json) {
    return GetTripInfoModel(
      startLocation: json['startLocation'] == null
          ? null
          : StartLocation.fromJson(
              json['startLocation'] as Map<String, dynamic>),
      targetLocation: json['targetLocation'] == null
          ? null
          : TargetLocation.fromJson(
              json['targetLocation'] as Map<String, dynamic>),
      fromTitle: json['fromTitle'] as String?,
      toTitle: json['toTitle'] as String?,
      distance: double.parse(json['distance'].toString()),
      duration: double.parse(json['duration'].toString()),
      price: double.parse(json['price'].toString()),
      lowestFare: double.parse(json['lowestFare'].toString()),
      calculateB: double.parse(json['calculate_b'].toString()),
      subcategoryId: json['subcategoryId'] as String?,
      comfort: json['comfort'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'startLocation': startLocation?.toJson(),
        'targetLocation': targetLocation?.toJson(),
        'fromTitle': fromTitle,
        'toTitle': toTitle,
        'distance': distance,
        'duration': duration,
        'price': price,
        'lowestFare': lowestFare,
        'calculate_b': calculateB,
        'subcategoryId': subcategoryId,
        'comfort': comfort,
      };
}
