//
// import 'package:dartz/dartz.dart';
// import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
//
// import '../../../../core/error/failure.dart';
//
// class UpdateTripPriceFromClientUseCase {
//   final RideRepository repository;
//
//   UpdateTripPriceFromClientUseCase(this.repository);
//
//   Future<Either<Failure, bool>> call(UpdateTripPriceFromClientUseCaseParams params) {
//     return repository.updateTripPriceFromClient(params);
//   }
// }
//
// class UpdateTripPriceFromClientUseCaseParams {
//   final String tripId;
//   final double newOfferPrice;
//   final bool autoAccept;
//
//   UpdateTripPriceFromClientUseCaseParams({
//     required this.tripId,
//     required this.newOfferPrice,
//     required this.autoAccept,
//   });
//   toJson() => {'newOfferPrice': newOfferPrice, 'autoAccept': autoAccept};
// }