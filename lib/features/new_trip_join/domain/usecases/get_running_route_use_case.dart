
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/running_route_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';

import '../../../../core/error/failure.dart';

class GetRunningRouteUseCase {
  final CaptainShareRepository repository;

  GetRunningRouteUseCase(this.repository);

  Future<Either<Failure, RunningRouteEntity>> call(NoParams params) {
    return repository.getRunningRoute();
  }
}

