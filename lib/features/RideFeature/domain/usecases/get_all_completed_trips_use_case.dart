// import 'package:dartz/dartz.dart';
// import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';
// import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
//
// import '../../../../core/error/failure.dart';
//
// class GetAllCompletedTripsUseCase {
//   final RideRepository repository;
//   GetAllCompletedTripsUseCase(this.repository);
//
//   Future<Either<Failure, List<CompletedTripsEntity>>> call(GetAllCompletedTripsUseCaseParams params) {
//     return repository.getAllCompletedTrips(params);
//   }
// }
//
// class GetAllCompletedTripsUseCaseParams {
//   final int limit;
//   final int page;
//   GetAllCompletedTripsUseCaseParams(this.limit, this.page);
// }