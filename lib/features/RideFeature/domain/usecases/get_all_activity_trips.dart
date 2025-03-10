// import 'package:dartz/dartz.dart';
// import 'package:fourtyninehub/features/RideFeature/domain/entities/activity_trip_entity.dart';
// import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
//
// import '../../../../core/error/failure.dart';
//
// class GetAllActivityTripsUseCase {
//   final RideRepository repository;
//
//   GetAllActivityTripsUseCase(this.repository);
//
//   Future<Either<Failure, ActivityTripEntity>> call(GetAllActivityTripsUseCaseParams params) async => await repository.getAllActivityTrips(params);
// }
// class GetAllActivityTripsUseCaseParams {
//   int limit;
//   int page;
//
//   GetAllActivityTripsUseCaseParams({required this.limit, required this.page});
// }