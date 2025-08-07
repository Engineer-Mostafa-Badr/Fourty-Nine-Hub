import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/sub_category_entity.dart';
import '../repositories/subcategories_repo.dart';
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
