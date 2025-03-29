import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/dashboards/trips_response_entity.dart';
import '../../repositories/trip_repository.dart';
import 'get_available_ride_trips_use_case.dart';

class GetAvailableTripsUsecase 
    extends UseCase<TripsResponseEntity, AvailableRideTripsUseCaseParams>{
  final TripRepository repository;

  GetAvailableTripsUsecase(this.repository);

  @override
  Future<Either<Failure, TripsResponseEntity>> call(params) async {
    return await repository.getAvailableTrips(params);
  }
}
