// import 'package:dartz/dartz.dart';
// import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
//
// import '../../../../core/error/failure.dart';
//
// class CancelTripByRiderUseCase {
//   final RideRepository repository;
//
//   CancelTripByRiderUseCase(this.repository);
//
//   Future<Either<Failure, bool>> call(CancelTripByRiderUseCaseParams params) async => await repository.cancelTripByRider(params);
// }
//
// class CancelTripByRiderUseCaseParams {
//   final String tripId;
//   final String reasonId;
//   final String note;
//
//   CancelTripByRiderUseCaseParams(this.tripId, this.reasonId, this.note);
//
//   toJson() => {'reasonId': reasonId, 'note': note};
// }