import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../food_feature/restaurants_list/domain/entities/rate_response_entity.dart';
import '../../repositories/ride_repository.dart';
import '../dashboards/add_rate_with_driver_use_case.dart';



class ReadLoadingOfferUseCase extends UseCase<bool , String> {
  final RideRepository _repo;
  ReadLoadingOfferUseCase(this._repo);

  @override
  Future<Either<Failure, bool >> call(String params) {
    return _repo.readLoadingOffer(params);
  }
}
