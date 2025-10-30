import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/repositories/shared_address_repo.dart';

class GetCitiesUseCase extends UseCase<List<CityEntity>, String> {
  final SharedAddressRepo _repo;

  GetCitiesUseCase(this._repo);

  @override
  Future<Either<Failure, List<CityEntity>>> call(String params) {
    return _repo.getCities(params);
  }
}
