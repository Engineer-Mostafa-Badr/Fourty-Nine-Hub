
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/create_price_per_seat_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_price_per_seat_use_case.dart';

import '../../../../core/error/failure.dart';

class CreateRouteUseCase {
  final CaptainShareRepository repository;

  CreateRouteUseCase(this.repository);

  Future<Either<Failure, bool>> call(CreatePricePerSeatParams params) {
    return repository.createRoute(params);
  }
}

