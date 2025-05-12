import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/arrived_to_client_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class EmergencySupportUseCase extends UseCase<bool, EmergencySupportParams> {
  final TripRepository _repository;

  const EmergencySupportUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(EmergencySupportParams params) {
    return _repository.emergencySupport(params);
  }
}


class EmergencySupportParams{
  final String driverId;
  final String tripId;
  final String clientId;
  final String phone;
  final String type;
  final String description;
  final double? latitude;
  final double? longitude;

  EmergencySupportParams({required this.driverId, required this.tripId, required this.clientId, required this.phone, required this.type, required this.description, this.latitude, this.longitude});

  //toJson
  Map<String, dynamic> toJson() => {
    "driverId": driverId,
    "tripId": tripId,
    "clientId": clientId,
    "phone":phone,
    "type": type,
    "description": description,
    if(latitude!=null&&longitude!=null)"location": {
      "latitude": latitude,
      "longitude": longitude
    }
  };
}