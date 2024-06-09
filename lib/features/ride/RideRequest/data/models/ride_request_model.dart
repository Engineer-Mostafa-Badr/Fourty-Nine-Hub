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
      required super.categoryId,
      super.driverId,
      super.userId,
      required super.isAirConditioned,
      required super.id,
      required super.phone});

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "air_conditioner": isAirConditioned,
        "car_model_year": carTypes,
        "destination_lng": toLng,
        "destination_lat": toLat,
        "user_lng": fromLat,
        "user_lat": fromLng,
        "phone": phone,
        "price": 20,
        "passengers": 1,
        "from": fromAddress,
        "to": toAddress,
        "auto_accept": autoAccept
      };
}
