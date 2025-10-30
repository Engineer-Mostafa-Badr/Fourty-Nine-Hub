import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/repositories/shared_address_repo.dart';

class GetGovernoratesUseCase
    extends UseCase<List<GovernorateEntity>, NoParams> {
  final SharedAddressRepo _repo;

  GetGovernoratesUseCase(this._repo);

  @override
  Future<Either<Failure, List<GovernorateEntity>>> call(NoParams params) {
    return _repo.getGovernorates();
  }
}
