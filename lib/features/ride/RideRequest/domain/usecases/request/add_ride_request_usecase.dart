import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/ride_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/ride_request_repo.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/enums/ride_services_enum.dart';


class AddRideRequestUseCase
    extends UseCase<String, RideRequestModel> {
  final RideRequestRepo _repo;
  AddRideRequestUseCase(this._repo);
  @override
  Future<Either<Failure, String>> call(
      RideRequestModel params) {
            return _repo.addNormalRequest(request: params);

  }
}
