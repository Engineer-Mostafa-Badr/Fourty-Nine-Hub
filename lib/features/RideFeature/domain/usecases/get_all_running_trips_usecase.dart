// import 'package:dartz/dartz.dart';
// import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';
// import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
//
// import '../../../../core/error/failure.dart';
//
// class GetAllRunningTripsUseCase {
//   final RideRepository repository;
//   GetAllRunningTripsUseCase(this.repository);
//
//   Future<Either<Failure, List<RunningTripsEntity>>> call(GetAllRunningTripsUseCaseParams params) {
//     return repository.getAllRunningTrips(params);
//   }
// }
//
// class GetAllRunningTripsUseCaseParams {
//   final int limit;
//   final int page;
//   GetAllRunningTripsUseCaseParams(this.limit, this.page);
// }