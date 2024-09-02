import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/subcategories/data/datasources/subcategories_remote_datasource.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/repositories/subcategories_repo.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/get_sub_categories_use_case.dart';

class SubcategoriesRepoImpl implements SubcategoriesRepo {
  final SubcategoriesRemoteDataSource _remoteDataSource;

  SubcategoriesRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> getSubcategories(
      GetSubCategoriesParams params) {
    return _remoteDataSource.getSubcategories(params);
  }

  @override
  Future<Either<Failure, bool>> toggleFavoriteSubcategory(String sucategoryId) {
    return _remoteDataSource.toggleFavoriteSubcategory(sucategoryId);
  }
  @override
  Future<Either<Failure, bool>> toggleFavoriteCategory(String sucategoryId) {
    return _remoteDataSource.toggleFavoriteCategory(sucategoryId);
  }

  @override
  Future<Either<Failure, bool>> deleteFavoriteCategory(String sucategoryId) {
    return _remoteDataSource.deleteFavoriteCategory(sucategoryId);

  }
}
