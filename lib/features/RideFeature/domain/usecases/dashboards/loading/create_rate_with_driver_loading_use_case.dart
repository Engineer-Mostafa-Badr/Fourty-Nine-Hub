import 'package:dartz/dartz.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../food_feature/restaurants_list/domain/entities/rate_response_entity.dart';
import '../../../repositories/trip_repository.dart';

class AddRateWithDriverLoadingUseCase extends UseCase<RateResponseEntity , AddRateWithDriverLoadingParams> {
  final TripRepository _repo;
  AddRateWithDriverLoadingUseCase(this._repo);

  @override
  Future<Either<Failure, RateResponseEntity >> call(AddRateWithDriverLoadingParams params) {
    return _repo.addRateWithDriverLoading(params);
  }
}
class AddRateWithDriverLoadingParams {
  final String tripId;
  final num rate;
  final String comment;

  AddRateWithDriverLoadingParams({
    required this.tripId,
    required this.rate,
    required this.comment,
  });
  Map<String, dynamic> toJson() => {
    'ratingValue': rate,
    'comment': comment,

  };

}
