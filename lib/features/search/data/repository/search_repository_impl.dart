import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/search/data/data_source/search_remote_data_source.dart';
import 'package:fourtyninehub/features/search/domain/entity/main_category_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';

import '../../domain/repository/search_repository.dart';

class SearchRepositoryImpl extends SearchRepository{
  final SearchRemoteDataSource _searchRemoteDataSource;

  SearchRepositoryImpl(this._searchRemoteDataSource);
  @override
  Future<Either<Failure, List<MainSubCategorySearchEntity>>> fetchSearch(SearchParams params) {
   return _searchRemoteDataSource.fetchSearch(params);
  }
}