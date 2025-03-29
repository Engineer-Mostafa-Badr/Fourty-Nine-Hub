import 'package:dartz/dartz.dart';

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

class CreateNewOfferDashboardUsecaseParam {
  CreateNewOfferDashboardUsecaseParam({
    required this.priceOffer,
    required this.location,
    required this.tripId,
  });

  final int priceOffer;
  final CreateOfferLocation? location;
  final String tripId;

  Map<String, dynamic> toJson() => {
        "priceOffer": priceOffer,
        "location": location?.toJson(),
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
