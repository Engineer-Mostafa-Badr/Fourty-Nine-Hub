import 'package:fourtyninehub/core/enums/ride_services_enum.dart';

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
      super.vechileId,
      super.price,
      super.passengers,
      required super.isAirConditioned,
      required super.id,
      required super.phone});

  Map<String, dynamic> toJson() => service == RideServicesEnum.pickMe ||
          service == RideServicesEnum.comeWithYou
      ? {
          if (service == RideServicesEnum.comeWithYou)
            "vehicleId": vechileId ?? "6655b7fca0e144a679df98be",
          "categoryId": categoryId,
          "startLocation": [fromLat, fromLng],
          "targetLocation": [toLat, toLng],
          "from": fromAddress,
          "to": toAddress,
          "passengers": passengers ?? 1,
          "price": price,
          "phone": phone,
          "time": DateTime.now().millisecondsSinceEpoch, // timestamp utc
          "isRepeat": false,
          "note": "optional", // optional
          "distance": 4499484,
          "duration": 147270
        }
      : {
          "subCategory": categoryId,
          "startLocation": [fromLat, fromLng],
          "targetLocation": [toLat, toLng],

          "passengers": passengers ?? 1,
          "autoAccept": autoAccept,
          "price": price,
          "phone": phone,
          "scheduleTime":
              DateTime.now().millisecondsSinceEpoch, // timestamp utc
          "paymentMethod": "cash",
          "note": "optional", // optional
        };
}
