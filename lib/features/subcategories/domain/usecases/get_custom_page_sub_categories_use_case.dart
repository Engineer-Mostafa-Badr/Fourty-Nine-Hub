import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/repositories/subcategories_repo.dart';
import '../../../../core/abstract/use_case.dart';

class GetCustomPageSubCategoriesUseCase
    extends UseCase<List<SubCategoryEntity>, GetCustomPageSubCategoriesParams> {
  final SubcategoriesRepo _repo;

  GetCustomPageSubCategoriesUseCase(this._repo);

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> call(
      GetCustomPageSubCategoriesParams params) {
    return _repo.getCustomPageSubcategories(params);
  }
}

class GetCustomPageSubCategoriesParams {
  String mainCategoryId;

  GetCustomPageSubCategoriesParams({required this.mainCategoryId,
  });
}
