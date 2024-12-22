import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/search/domain/repository/search_repository.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

class FetchSearchSubCategoryUseCase
    extends UseCase<List<SubCategoryEntity>, SearchParams> {
  final SearchRepository _searchRepository;

  FetchSearchSubCategoryUseCase(this._searchRepository);

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> call(
      SearchParams params) async {
    return await _searchRepository.fetchSearchSubCategory(params);
  }
}
