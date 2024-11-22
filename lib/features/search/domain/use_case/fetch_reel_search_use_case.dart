import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/search/domain/entity/reels_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/repository/search_repository.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';


class FetchReelSearchUseCase
    extends UseCase<List<ReelsSearchEntity>, SearchParams> {
  final SearchRepository _searchRepository;

  FetchReelSearchUseCase(this._searchRepository);

  @override
  Future<Either<Failure, List<ReelsSearchEntity>>> call(SearchParams params)async {
    return await _searchRepository.fetchReelSearch(params);
  }
}