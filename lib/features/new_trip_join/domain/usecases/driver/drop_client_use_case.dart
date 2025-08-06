import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';

class DropClientUseCase {
  final CaptainShareRepository repository;

  DropClientUseCase(this.repository);

  Future<Either<Failure, bool>> call(DropClientParams params) {
    return repository.dropClient(params);
  }
}

class DropClientParams {
  final String routeId;
  final String passengerId;
  final double latitude;
  final double longitude;

  DropClientParams({required this.routeId, required this.passengerId, required this.latitude, required this.longitude});

  //toJson
  Map<String, dynamic> toJson() => {
    "passengerId": passengerId,
    "dropoffLocation": {
      "longitude": longitude,
      "latitude": latitude
    }
  };
}
