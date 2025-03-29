import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../repositories/trip_repository.dart';

class CreateDriverRatingUsecase {
  final TripRepository repository;

  CreateDriverRatingUsecase(this.repository);

  Future<Either<Failure, bool>> call(
      CreateUpdateDriverRatingUsecaseParam params) async {
    return repository.createDriverRating(params);
  }
}

class CreateUpdateDriverRatingUsecaseParam {
  CreateUpdateDriverRatingUsecaseParam({
    required this.comment,
    required this.ratingValue,
    required this.tripId,
  });

  final String tripId;
  final int? ratingValue;
  final String comment;

  Map<String, dynamic> toJson() => {
        if (ratingValue == null) "newComment": comment else "comment": comment,
        if (ratingValue != null) "ratingValue": ratingValue,
        "tripId": tripId
      };
}
