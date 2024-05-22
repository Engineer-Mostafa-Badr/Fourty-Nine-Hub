import '../../domain/entity/ride_request_entity.dart';

class RideRequestModel extends RideRequestEntity {
  RideRequestModel(
      {required super.fromAddress,
      required super.toAddress,
      required super.fromLat,
      required super.fromLng,
      required super.toLat,
      required super.toLng,
      required super.autoAccept,
      required super.carTypes,
      super.driverId,
      super.userId,
      required super.isAirConditioned,
      required super.id});
}
