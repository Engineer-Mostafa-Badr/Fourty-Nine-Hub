import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../entity/chance_ads_pagination_entity.dart';
import '../repository/chance_repository.dart';

class GetAllChanceAdsUseCase {
  final ChanceRepository repository;

  GetAllChanceAdsUseCase(this.repository);

  Future<Either<Failure, ChanceAdsPaginationEntity>> call(GetAllChanceAdsParams params) async {
    return await repository.getAllChanceAds(params);
  }
}

class GetAllChanceAdsParams {
  final PaginationParams paginationParams;

  GetAllChanceAdsParams({required this.paginationParams});
}