import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/get_sub_categories_use_case.dart';

abstract class SubcategoriesRemoteDataSource {
  Future<Either<Failure, List<SubCategoryEntity>>> getSubcategories(
      GetSubCategoriesParams params);

  Future<Either<Failure, bool>> toggleFavoriteSubcategory(String sucategoryId);
  Future<Either<Failure, bool>> toggleFavoriteCategory(String sucategoryId);
  Future<Either<Failure, bool>> deleteFavoriteCategory(String sucategoryId);
}

class SubcategoriesRemoteDataSourceImpl
    implements SubcategoriesRemoteDataSource {
  final ApiConsumer _apiConsumer;

  SubcategoriesRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> getSubcategories(
      GetSubCategoriesParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.subCategories(mainCategoryId: params.mainCategoryId),
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
  Future<Either<Failure, bool>> toggleFavoriteCategory(String sucategoryId) async {
    final response = await _apiConsumer
        .post(EndPoints.toggleFavoriteCategory(sucategoryId));
    return response.fold(
            (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> deleteFavoriteCategory(String sucategoryId)async {
    final response = await _apiConsumer
        .delete(EndPoints.toggleFavoriteCategory(sucategoryId));
    return response.fold(
            (failure) => Left(failure), (data) => Right(data['status']));
  }
}
