import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/get_sub_categories_use_case.dart';

import '../usecases/get_custom_page_sub_categories_use_case.dart';

abstract class SubcategoriesRepo {
  Future<Either<Failure, List<SubCategoryEntity>>> getSubcategories(
      GetSubCategoriesParams params);

  Future<Either<Failure, bool>> toggleFavoriteSubcategory(String sucategoryId);

  Future<Either<Failure, bool>> toggleFavoriteCategory(String sucategoryId);

  Future<Either<Failure, bool>> deleteFavoriteCategory(String sucategoryId);

  Future<Either<Failure, List<SubCategoryEntity>>> getCustomPageSubcategories(
      GetCustomPageSubCategoriesParams params);
}
