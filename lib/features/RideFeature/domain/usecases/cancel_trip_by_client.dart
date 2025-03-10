import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class CancelTripByClientUseCase {
  final RideRepository repository;

  CancelTripByClientUseCase(this.repository);

  Future<Either<Failure, bool>> call(CancelTripByClientUseCaseParams params) async => await repository.cancelTripByClient(params);
}

class CancelTripByClientUseCaseParams {
  final String tripId;
  final String reasonId;
  final String note;
  final double lat;
  final double lng;

  CancelTripByClientUseCaseParams(this.tripId, this.reasonId, this.note, this.lat, this.lng);

  toJson() => {'reasonId': reasonId, 'note': note, 'riderLocation': [lat, lng]};
}