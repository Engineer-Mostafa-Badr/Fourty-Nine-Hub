import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/ride_repository.dart';

class RatingDriverByClientUseCase {
  final RideRepository repository;

  RatingDriverByClientUseCase({required this.repository});

  Future<Either<Failure, bool>> call(RatingDriverByClientUseCaseParams params) {
    return repository.ratingDriverByClient(params);
  }
}

class RatingDriverByClientUseCaseParams {
  final String tripId;
  final String? comment;
  final int ratingValue;

  RatingDriverByClientUseCaseParams({
    required this.tripId,
    this.comment,
    required this.ratingValue,
  });

  // toJson
  Map<String, dynamic> toJson() => {'tripId': tripId, if (comment != null) 'comment': comment, 'ratingValue': ratingValue};
}