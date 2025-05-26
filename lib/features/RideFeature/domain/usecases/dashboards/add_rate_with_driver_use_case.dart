import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../../../food_feature/restaurants_list/domain/entities/rate_response_entity.dart';
import '../../repositories/trip_repository.dart';


class AddRateWithDriverUseCase extends UseCase<RateResponseEntity , AddRateWithDriverParams> {
  final TripRepository _repo;
  AddRateWithDriverUseCase(this._repo);

  @override
  Future<Either<Failure, RateResponseEntity >> call(AddRateWithDriverParams params) {
    return _repo.addRateWithDriver(params);
  }
}
class AddRateWithDriverParams {
  final String tripId;
  final num rate;
  final String comment;

  AddRateWithDriverParams({
    required this.tripId,
    required this.rate,
    required this.comment,
  });
  Map<String, dynamic> toJson() => {
    'tripId': tripId,
    'ratingValue': rate,
    'comment': comment,

  };

}
