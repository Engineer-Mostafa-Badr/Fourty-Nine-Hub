import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';

class PickClientUseCase {
  final CaptainShareRepository repository;

  PickClientUseCase(this.repository);

  Future<Either<Failure, bool>> call(PickClientParams params) {
    return repository.pickClient(params);
  }
}

class PickClientParams {
  final String routeId;
  final String passengerId;
  final String otp;

  PickClientParams({required this.routeId, required this.passengerId, required this.otp});

  //toJson
  Map<String, dynamic> toJson() => {
        'passengerId': passengerId,
        'otp': otp,
      };
}
