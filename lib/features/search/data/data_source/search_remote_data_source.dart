import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/search/data/model/main_category_search_model.dart';
import 'package:fourtyninehub/features/search/data/model/user_search_model.dart';
import 'package:fourtyninehub/features/search/domain/entity/main_category_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/user_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';

import '../../../../core/error/failure.dart';

abstract class SearchRemoteDataSource {
  Future<Either<Failure, List<MainSubCategorySearchEntity>>> fetchSearch(
      SearchParams params);
  Future<Either<Failure, List<UserSearchEntity>>> fetchUserSearch(
      SearchParams params);
}

class SearchRemoteDataSourceImpl extends SearchRemoteDataSource {
  final ApiConsumer _apiConsumer;

  SearchRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<MainSubCategorySearchEntity>>> fetchSearch(
      SearchParams params) async {
    final response =
        await _apiConsumer.get(EndPoints.search(params), data: params.toJson());
    return response.fold(
      (failure) => Left(failure),
      (response) => Right((response['data'] as List)
          .map((e) => MainSubCategorySearchModel.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, List<UserSearchEntity>>> fetchUserSearch(
      SearchParams params) async {
    final response =
        await _apiConsumer.get(EndPoints.search(params), data: params.toJson());
    return response.fold(
      (failure) => Left(failure),
      (response) => Right((response['data'] as List)
          .map((e) => UserSearchModel.fromJson(e))
          .toList()),
    );
  }
}
