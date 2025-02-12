// import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/trip_info_entity.dart';
//
// class TripInfoModel extends TripInfoEntity {
//   @override
//   final String? type;
//   @override
//   final String? polyline;
//
//   TripInfoModel({
//     super.price,
//     super.distance,
//     super.duration,
//     super.destinationAddress,
//     super.originAddress,
//     this.type,
//     this.polyline,
//   });
//
//   @override
//   String toString() {
//     return 'TripJoinModel(price: $price, distance: $distance, duration: $duration, destinationAddress: $destinationAddress, originAddress: $originAddress, type: $type, polyline: $polyline)';
//   }
//
//   factory TripInfoModel.fromJson(Map<String, dynamic> json) => TripInfoModel(
//         price: (json['price'] as num?)?.toDouble(),
//         distance: (json['distance'] as num?)?.toDouble(),
//         duration: (json['duration'] as num?)?.toDouble(),
//         destinationAddress: json['destinationAddress'] as String?,
//         originAddress: json['originAddress'] as String?,
//         type: json['type'] as String?,
//         polyline: json['polyline'] as String?,
//       );
//
//   Map<String, dynamic> toJson() => {
//         'price': price,
//         'distance': distance,
//         'duration': duration,
//         'destinationAddress': destinationAddress,
//         'originAddress': originAddress,
//         'type': type,
//         'polyline': polyline,
//       };
// }
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/trip_info_entity.dart';
import 'package:latlong2/latlong.dart';

class TripInfoModel extends TripInfoEntity {
  @override
  final String? type;
  @override
  final List<LatLng>? polyline;

  TripInfoModel({
    super.price,
    super.distance,
    super.duration,
    super.destinationAddress,
    super.originAddress,
    this.type,
    this.polyline,
  });

  @override
  String toString() {
    return 'TripInfoModel(price: $price, distance: $distance, duration: $duration, destinationAddress: $destinationAddress, originAddress: $originAddress, type: $type, polyline: $polyline)';
  }

  factory TripInfoModel.fromJson(Map<String, dynamic> json) {
    return TripInfoModel(
      price: (json['price'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      duration: (json['duration'] as num?)?.toDouble(),
      destinationAddress: json['destinationAddress'] as String?,
      originAddress: json['originAddress'] as String?,
      type: json['type'] as String?,
      polyline: (json['polyline'] as List<dynamic>?)
          ?.map<LatLng>((point) => LatLng((point as List)[1], point[0]))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'price': price,
    'distance': distance,
    'duration': duration,
    'destinationAddress': destinationAddress,
    'originAddress': originAddress,
    'type': type,
    'polyline': polyline?.map((point) => [point.longitude, point.latitude]).toList(),
  };
}
