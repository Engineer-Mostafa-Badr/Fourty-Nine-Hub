import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/governorate_entity.dart';

abstract class SharedAddressRepo {
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates();

  Future<Either<Failure, List<CityEntity>>> getCities(String governorateId);
}
