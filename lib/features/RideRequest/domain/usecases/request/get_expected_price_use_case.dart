import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/expected_price_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/google_search_results.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/params/expected_price_params.dart';
import 'package:fourtyninehub/features/RideRequest/domain/repositories/ride_request_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../data/models/address_search_params_model.dart';

class GetExpectedPriceUseCase
    extends UseCase<ExpectedPriceModel, ExpectedPriceParams> {
  final RideRequestRepo _repo;
  GetExpectedPriceUseCase(this._repo);

  @override
  Future<Either<Failure, ExpectedPriceModel>> call(ExpectedPriceParams params) {
    return _repo.getExpectedPrice(params: params);
  }
}
