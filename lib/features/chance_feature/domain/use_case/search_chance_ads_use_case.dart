import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../entity/chance_ad_entity.dart';
import '../repository/chance_repository.dart';

class SearchChanceAdsUseCase {
  final ChanceRepository repository;

  SearchChanceAdsUseCase(this.repository);

  Future<Either<Failure, List<ChanceAdEntity>>> call(SearchChanceAdsParams params) async {
    return await repository.searchChanceAds(params);
  }
}

class SearchChanceAdsParams {
  final String keyword;

  SearchChanceAdsParams({required this.keyword});
}