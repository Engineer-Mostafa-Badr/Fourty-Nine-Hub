import 'package:dartz/dartz.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../ride/RideRequest/data/models/expected_price_model.dart';
import '../../../../ride/RideRequest/data/models/params/expected_price_params.dart';
import '../repositories/create_shipping_repo.dart';

class GetShippingExpectedPriceUseCase
    extends UseCase<ExpectedPriceModel, ExpectedPriceParams> {
  final CreateShippingRepo _repo;
  GetShippingExpectedPriceUseCase(this._repo);

  @override
  Future<Either<Failure, ExpectedPriceModel>> call(ExpectedPriceParams params) {
    return _repo.getExpectedPrice(params: params);
  }
}
