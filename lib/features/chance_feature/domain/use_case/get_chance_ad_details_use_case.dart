import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../entity/chance_ad_entity.dart';
import '../repository/chance_repository.dart';

class GetChanceAdDetailsUseCase {
  final ChanceRepository repository;

  GetChanceAdDetailsUseCase(this.repository);

  Future<Either<Failure, ChanceAdEntity>> call(GetChanceAdDetailsParams params) async {
    return await repository.getChanceAdDetails(params);
  }
}

class GetChanceAdDetailsParams {
  final String adId;

  GetChanceAdDetailsParams({required this.adId});
}