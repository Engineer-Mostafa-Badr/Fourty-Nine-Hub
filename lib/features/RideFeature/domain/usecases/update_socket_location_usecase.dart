
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

class UpdateSocketLocationUseCase extends UseCase<bool, UpdateSocketLocationParams> {
  final RideRepository _repo;

  UpdateSocketLocationUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(UpdateSocketLocationParams params) {
    return _repo.listenToUpdateLocation(params);
  }
}

class UpdateSocketLocationParams {
  final double latitude;
  final double longitude;

  UpdateSocketLocationParams({
    required this.latitude,
    required this.longitude,
  });

  //toJson
  Map<String, dynamic> toJson() => {
      "location": {
        "longitude": longitude,
        "latitude": latitude
      }
      };
}
