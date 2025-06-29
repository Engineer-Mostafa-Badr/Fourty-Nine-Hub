import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class GetAllHistoryTripsUseCase {
  final RideRepository repository;
  GetAllHistoryTripsUseCase(this.repository);

  Future<Either<Failure, List<HistoryTripsEntity>>> call(GetAllHistoryTripsUseCaseParams params) {
    return repository.getAllHistoryTrips(params);
  }
}

class GetAllHistoryTripsUseCaseParams {
  final int limit;
  final int page;
  GetAllHistoryTripsUseCaseParams(this.limit, this.page);
}