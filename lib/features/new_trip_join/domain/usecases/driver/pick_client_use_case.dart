import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';

class PickClientUseCase {
  final CaptainShareRepository repository;

  PickClientUseCase(this.repository);

  Future<Either<Failure, String>> call(PickClientParams params) {
    return repository.pickClient(params);
  }
}

class PickClientParams {
  final String routeId;
  final String passengerId;
  final String? otp;

  PickClientParams({required this.routeId, required this.passengerId, this.otp});

  //toJson
  Map<String, dynamic> toJson() => {
        'passengerId': passengerId,
        if (otp != null&& otp!.isNotEmpty) 'otp': otp,
      };
}
