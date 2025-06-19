import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/create_no_track_trip_entity.dart';
import '../../repositories/ride_repository.dart';

class UpdateClientRateNonSocketUseCase
    extends UseCase<CreateNonTrackTripEntity, UpdateClientRateParams> {
  final RideRepository _repo;

  UpdateClientRateNonSocketUseCase(this._repo);

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> call(UpdateClientRateParams params) {
    return _repo.updateClientRateNonSocket(params);
  }
}
class UpdateClientRateParams {
  final String tripId;
  final String newComment;
  final num newRatingValue;

  UpdateClientRateParams({
    required this.tripId,
    required this.newComment,
    required this.newRatingValue,


  });

  Map<String, dynamic> toJson() => {
    'tripId': tripId,
    'newComment': newComment,
    'newRatingValue': newRatingValue,

  };
}

