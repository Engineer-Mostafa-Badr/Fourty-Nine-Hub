import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/dashboards/trips_response_entity.dart';
import '../../repositories/trip_repository.dart';

class GetPastTripsUsecase extends UseCase<TripsResponseEntity, NoParams> {
  final TripRepository repository;

  GetPastTripsUsecase(this.repository);

  @override
  Future<Either<Failure, TripsResponseEntity>> call(NoParams params) async {
    return await repository.getPastTrips();
  }
}
