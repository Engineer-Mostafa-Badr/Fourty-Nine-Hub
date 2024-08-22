import 'package:fourtyninehub/features/trip_join/domain/entities/trip_info_entity.dart';

class TripInfoModel extends TripInfoEntity {
  String? destinationAddress;
  String? originAddress;

  TripInfoModel({
    super.price,
    super.distance,
    super.duration,
    this.destinationAddress,
    this.originAddress,
  });

  @override
  String toString() {
    return 'TripJoinModel(price: $price, distance: $distance, duration: $duration, destinationAddress: $destinationAddress, originAddress: $originAddress)';
  }

  factory TripInfoModel.fromJson(Map<String, dynamic> json) => TripInfoModel(
        price: (json['price'] as num?)?.toDouble(),
        distance: (json['distance'] as num?)?.toDouble(),
        duration: (json['duration'] as num?)?.toDouble(),
        destinationAddress: json['destinationAddress'] as String?,
        originAddress: json['originAddress'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'price': price,
        'distance': distance,
        'duration': duration,
        'destinationAddress': destinationAddress,
        'originAddress': originAddress,
      };
}
