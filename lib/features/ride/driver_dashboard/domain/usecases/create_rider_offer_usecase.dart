import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/utils/device_id.dart';

import '../repositories/driver_dashboard_repo.dart';

class CreateRiderOfferUseCase extends UseCase<bool, CreateRiderOfferParams> {
  final DriverDashboardRepo _repository;

  const CreateRiderOfferUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(CreateRiderOfferParams params) {
    return _repository.createOffer(params: params);
  }
}

class CreateRiderOfferParams {
  final String tripId;
  final num price;
  final double lat;
  final double lng;
  CreateRiderOfferParams({
    required this.tripId,
    required this.price,
    required this.lat,
    required this.lng,
  });
  Future<Map<String, dynamic>> toJson() async => {
    "priceOffer": price,
    "driverDeviceId": await getDeviceId(),
    "location": {
      "latitude": lat,
      "longitude": lng
    }
  };
}
