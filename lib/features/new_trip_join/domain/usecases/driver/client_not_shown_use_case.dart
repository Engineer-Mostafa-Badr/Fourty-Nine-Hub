import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';

class ClientNotShownUseCase {
  final CaptainShareRepository repository;

  ClientNotShownUseCase(this.repository);

  Future<Either<Failure, bool>> call(ClientNotShownParams params) {
    return repository.clientNotShown(params);
  }
}

class ClientNotShownParams {
  final String routeId;
  final String passengerId;
  final double latitude;
  final double longitude;

  ClientNotShownParams({required this.routeId, required this.passengerId, required this.latitude, required this.longitude});

  //toJson
  Map<String, dynamic> toJson() => {
    "passengerId": passengerId,
    "location": {
      "longitude": longitude,
      "latitude": latitude
    }
  };
}
