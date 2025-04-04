import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../repositories/trip_repository.dart';
import 'create_driver_rating_usecase.dart';

class UpdateDriverRatingUsecase {
  final TripRepository repository;

  UpdateDriverRatingUsecase(this.repository);

  Future<Either<Failure, bool>> call(
      CreateUpdateDriverRatingUsecaseParam params) async {
    return repository.updateDriverRating(params);
  }
}


