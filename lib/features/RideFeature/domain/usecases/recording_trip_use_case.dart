import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class RecordingTripUseCase {
  final RideRepository repository;

  RecordingTripUseCase(this.repository);

  Future<Either<Failure, bool>> call(RecordingTripUseCaseParams params) {
    return repository.recordingTrip(params);
  }
}
class RecordingTripUseCaseParams {
  final String tripId;
  final String mediaId;

  RecordingTripUseCaseParams(this.tripId, this.mediaId);

  toJson() => {'mediaId': mediaId};
}