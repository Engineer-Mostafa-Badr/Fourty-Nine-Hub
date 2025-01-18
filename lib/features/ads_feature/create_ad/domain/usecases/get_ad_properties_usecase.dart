import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/repositories/create_ad_repo.dart';

class GetAdPropertiesUsecase extends UseCase<List<AdPropertiesEntity>, GetAdPropertiesParams> {
  final CreateAdRepo _repo;

  GetAdPropertiesUsecase(this._repo);

  @override
  Future<Either<Failure, List<AdPropertiesEntity>>> call(
    GetAdPropertiesParams params,
  ) {
    return _repo.getAdProperties(params: params);
  }
}

class GetAdPropertiesParams{
  final String id;
  final bool? fromMarriage;

  GetAdPropertiesParams({required this.id, required this.fromMarriage});
}
