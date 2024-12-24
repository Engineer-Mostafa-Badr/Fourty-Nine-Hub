import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/search/domain/entity/ads_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/repository/search_repository.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';

class FetchAdsSearchUseCase
    extends UseCase<List<AdsSearchEntity>, SearchParams> {
  final SearchRepository _searchRepository;

  FetchAdsSearchUseCase(this._searchRepository);

  @override
  Future<Either<Failure, List<AdsSearchEntity>>> call(
      SearchParams params) async {
    return await _searchRepository.fetchAdsSearch(params);
  }
}
