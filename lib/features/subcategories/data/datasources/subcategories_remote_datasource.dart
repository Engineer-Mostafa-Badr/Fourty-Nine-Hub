import 'package:dartz/dartz.dart';
import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';
import '../../../ads_feature/ads/data/models/Ad_model.dart';
import '../models/sub_category_model.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../../domain/usecases/get_sub_categories_use_case.dart';
import '../../domain/usecases/search_ads_use_case.dart';

import '../../domain/usecases/get_custom_page_sub_categories_use_case.dart';

abstract class SubcategoriesRemoteDataSource {
  Future<Either<Failure, List<SubCategoryEntity>>> getSubcategories(
      GetSubCategoriesParams params);

  Future<Either<Failure, bool>> toggleFavoriteSubcategory(String sucategoryId);

  Future<Either<Failure, bool>> toggleFavoriteCategory(String sucategoryId);

  Future<Either<Failure, bool>> deleteFavoriteCategory(String sucategoryId);

  Future<Either<Failure, List<SubCategoryEntity>>> getCustomPageSubcategories(
      GetCustomPageSubCategoriesParams params);

  Future<Either<Failure, List<AdModel>>> searchAds(SearchAdsParams params);
}

class SubcategoriesRemoteDataSourceImpl
    implements SubcategoriesRemoteDataSource {
  final ApiConsumer _apiConsumer;

  SubcategoriesRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> getSubcategories(
      GetSubCategoriesParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.mainSubCategories(params: params),
      queryParameters: params.paginationParams.toJson(),
    );

    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['subcategories'] as List)
            .map((e) => SubCategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> toggleFavoriteSubcategory(
      String sucategoryId) async {
    final response = await _apiConsumer
        .post(EndPoints.toggleFavoriteSubcategory(sucategoryId));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> toggleFavoriteCategory(
      String sucategoryId) async {
    final response =
        await _apiConsumer.post(EndPoints.toggleFavoriteCategory(sucategoryId));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> deleteFavoriteCategory(
      String sucategoryId) async {
    final response = await _apiConsumer
        .delete(EndPoints.toggleFavoriteCategory(sucategoryId));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> getCustomPageSubcategories(
      GetCustomPageSubCategoriesParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.customPageSubCategories(params: params),
    );
    print('getCustomPageSubcategories');
    return response.fold((failure) => Left(failure), (data) {
      print(data['data'].runtimeType);
      return Right((data['data'] as List)
          .map((e) => SubCategoryModel.fromJson(e))
          .toList());
    });
  }

  @override
  Future<Either<Failure, List<AdModel>>> searchAds(
      SearchAdsParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.searchAdsByMainCategory(
            mainCategoryId: params.mainCategoryId),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        // print(data['data'].runtimeType);
        return Right((data['data']['ads'] as List)
            .map((e) => AdModel.fromJson(e))
            .toList());
      });
    } catch (e) {
      print(e);
      return Left(UnknownFailure(e.toString()));
    }
  }
}
