
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';

import '../../../../core/error/failure.dart';

class GetRouteDetailsUseCase {
  final CaptainShareRepository repository;

  GetRouteDetailsUseCase(this.repository);

  Future<Either<Failure, MyBookingEntity>> call(String params) {
    return repository.getRouteDetails(params);
  }
}

