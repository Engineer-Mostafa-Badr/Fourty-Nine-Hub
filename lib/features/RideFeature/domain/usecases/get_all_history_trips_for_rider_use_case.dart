import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trip_for_rider_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class GetAllHistoryTripsForRiderUseCase {
  final RideRepository repository;
  GetAllHistoryTripsForRiderUseCase(this.repository);

  Future<Either<Failure, List<HistoryTripForRiderEntity>>> call(GetAllHistoryTripsForRiderUseCaseParams params) async => await repository.getAllHistoryTripsForRider(params);
}

class GetAllHistoryTripsForRiderUseCaseParams{
  final int limit;
  final int page;

  GetAllHistoryTripsForRiderUseCaseParams({required this.limit, required this.page});
}