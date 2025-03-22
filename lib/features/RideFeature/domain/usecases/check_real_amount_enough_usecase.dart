import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class CheckRealAmountEnoughUseCase
    extends UseCase<bool, double> {
final RideRepository _repo;
CheckRealAmountEnoughUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(double params) async{
    return await _repo.checkRealAmountEnough(params);
  }
}
