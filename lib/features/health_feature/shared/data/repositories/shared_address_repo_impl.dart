import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/shared/data/datasources/shared_address_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/repositories/shared_address_repo.dart';

class SharedAddressRepoImpl implements SharedAddressRepo {
  final SharedAddressRemoteDataSource _remote;

  SharedAddressRepoImpl(this._remote);

  @override
  Future<Either<Failure, List<CityEntity>>> getCities(String governorateId) {
    return _remote.getCities(governorateId);
  }

  @override
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates() {
    return _remote.getGovernorates();
  }
}
