
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';

class GetDriverRunningRouteUseCase {
  final CaptainShareRepository repository;

  GetDriverRunningRouteUseCase(this.repository);

  Future<Either<Failure, MyBookingEntity>> call(NoParams params) {
    return repository.getDriverRunningRoute();
  }
}

