import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/utils/device_id.dart';

import '../../../../../core/error/failure.dart';
import '../../repositories/trip_repository.dart';

class CreateNewOfferDashboardUsecase {
  final TripRepository repository;

  CreateNewOfferDashboardUsecase(this.repository);

  Future<Either<Failure, bool>> call(
      CreateNewOfferDashboardUsecaseParam params) async {
    return repository.createNewOffer(params);
  }
}

class CreateNewOfferNonSocketUsecase {
  final TripRepository repository;

  CreateNewOfferNonSocketUsecase(this.repository);

  Future<Either<Failure, bool>> call(
      CreateNewOfferDashboardUsecaseParam params) async {
    return repository.createNewOfferNonSocket(params);
  }
}

class CreateNewOfferDashboardUsecaseParam {
  CreateNewOfferDashboardUsecaseParam({
    required this.priceOffer,
     this.location,
    required this.tripId,
  });

  final int priceOffer;
  final CreateOfferLocation? location;
  final String tripId;

  Future<Map<String, dynamic>> toJson() async => {
        "priceOffer": priceOffer,
        "driverDeviceId": await getDeviceId(),
        // "location": location?.toJson(),
        "tripId": tripId
      };
}

class CreateOfferLocation {
  CreateOfferLocation({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() =>
      {"latitude": latitude, "longitude": longitude};
}
