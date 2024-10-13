import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/search/domain/entity/main_category_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/search_entity.dart';
import 'package:fourtyninehub/features/search/domain/repository/search_repository.dart';

class FetchSearchUseCase extends UseCase<List<MainSubCategorySearchEntity>,SearchParams>{
  final SearchRepository _searchRepository;

  FetchSearchUseCase(this._searchRepository);

  @override
  Future<Either<Failure, List<MainSubCategorySearchEntity>>> call(SearchParams params) async{
   return await _searchRepository.fetchSearch(params);
  }

}

class SearchParams{
  final String search;
  final PaginationParams params;

  SearchParams({required this.search, required this.params});

  Map<String,dynamic> toJson()=>{
    'search':search
  };
}