import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/dashboards/trips_response_entity.dart';
import '../../repositories/trip_repository.dart';

class GetAvailableTripsUsecase 
    extends UseCase<TripsResponseEntity, String>{
  final TripRepository repository;

  GetAvailableTripsUsecase(this.repository);

  @override
  Future<Either<Failure, TripsResponseEntity>> call(params) async {
    return await repository.getAvailableTrips(params);
  }
}
