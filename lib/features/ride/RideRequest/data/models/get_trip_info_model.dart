// class GetTripInfoModel {
//   double? price;
//   dynamic lowestFare;
//   String? from;
//   String? to;
//   List<dynamic>? startLocation;
//   List<dynamic>? targetLocation;
//   int? distance;
//   int? duration;
//   int? calculateB;
//   String? polyline;
//   String? type;
//   double? comfort;
//   GetTripInfoModel({
//     this.price,
//     this.lowestFare,
//     this.from,
//     this.to,
//     this.startLocation,
//     this.targetLocation,
//     this.distance,
//     this.comfort,
//     this.duration,
//     this.calculateB,
//     this.polyline,
//     this.type,
//   });
//
//   factory GetTripInfoModel.fromJson(Map<String, dynamic> json) {
//     return GetTripInfoModel(
//       price: (json['price'] as num?)?.toDouble(),
//       lowestFare: json['lowestFare'] as dynamic,
//       from: json['from'] as String?,
//       comfort: double.parse(json['comfort'].toString()),
//       to: json['to'] as String?,
//       startLocation: json['startLocation'] as List<dynamic>?,
//       targetLocation: json['targetLocation'] as List<dynamic>?,
//       distance: json['distance'] as int?,
//       duration: json['duration'] as int?,
//       calculateB: json['calculate_b'] as int?,
//       polyline: json['polyline'] as String?,
//       type: json['type'] as String?,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//         'price': price,
//         'lowestFare': lowestFare,
//         'from': from,
//         'to': to,
//         'startLocation': startLocation,
//         'targetLocation': targetLocation,
//         'distance': distance,
//         'duration': duration,
//         'calculate_b': calculateB,
//         'polyline': polyline,
//         'type': type,
//       };
// }


import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetTripInfoModel {
  double? price;
  dynamic lowestFare;
  String? from;
  String? to;
  List<double>? startLocation;
  List<double>? targetLocation;
  int? distance;
  int? duration;
  int? calculateB;
  List<LatLng>? polyline;
  String? type;
  double? comfort;

  GetTripInfoModel({
    this.price,
    this.lowestFare,
    this.from,
    this.to,
    this.startLocation,
    this.targetLocation,
    this.distance,
    this.comfort,
    this.duration,
    this.calculateB,
    this.polyline,
    this.type,
  });

  factory GetTripInfoModel.fromJson(Map<String, dynamic> json) {
    return GetTripInfoModel(
      price: (json['price'] as num?)?.toDouble(),
      lowestFare: json['lowestFare'],
      from: json['from'] as String?,
      to: json['to'] as String?,
      comfort: double.tryParse(json['comfort'].toString()),
      startLocation: (json['startLocation'] as List<dynamic>?)
          ?.map<double>((e) => (e as num).toDouble())
          .toList(),
      targetLocation: (json['targetLocation'] as List<dynamic>?)
          ?.map<double>((e) => (e as num).toDouble())
          .toList(),
      distance: json['distance'] as int?,
      duration: json['duration'] as int?,
      calculateB: json['calculate_b'] as int?,
      polyline: (json['polyline'] as List<dynamic>?)
          ?.map<LatLng>((point) => LatLng((point as List)[1], point[0]))
          .toList(),
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'price': price,
    'lowestFare': lowestFare,
    'from': from,
    'to': to,
    'startLocation': startLocation,
    'targetLocation': targetLocation,
    'distance': distance,
    'duration': duration,
    'calculate_b': calculateB,
    'polyline': polyline?.map((point) => [point.longitude, point.latitude]).toList(),
    'type': type,
    'comfort': comfort,
  };
}
