import 'package:fourtyninehub/core/enums/ride_services_enum.dart';

class RideRequestEntity {
  final String id;
  RideServicesEnum get service => getRideServiceEnum(value: categoryId);
  final String categoryId;
  final String fromAddress;
  final String toAddress;
  final int? userId;
  final int? driverId;
  final double fromLat;
  final double? price;
  final int? passengers;
  final String? vechileId;
  final double fromLng;
  final double toLat;
  final double toLng;
  final bool autoAccept;
  final List<String> carTypes;
  final bool isAirConditioned;
  final String phone;
  RideRequestEntity(
      {required this.id,
      required this.fromAddress,
      required this.toAddress,
      required this.categoryId,
      required this.vechileId,
      this.userId,
      this.driverId,
      this.price,
      this.passengers,
      required this.fromLat,
      required this.fromLng,
      required this.toLat,
      required this.toLng,
      required this.autoAccept,
      required this.phone,
      required this.carTypes,
      required this.isAirConditioned});
}
