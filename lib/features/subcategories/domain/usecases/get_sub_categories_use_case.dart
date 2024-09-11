import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/repositories/subcategories_repo.dart';
import '../../../../core/abstract/use_case.dart';

class GetSubCategoriesUseCase
    extends UseCase<List<SubCategoryEntity>, GetSubCategoriesParams> {
  final SubcategoriesRepo _repo;
  GetSubCategoriesUseCase(this._repo);

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> call(
      GetSubCategoriesParams params) {
    return _repo.getSubcategories(params);
  }
}

class GetSubCategoriesParams {
  String mainCategoryId;
  String userId;
  PaginationParams paginationParams;

  GetSubCategoriesParams(
      {required this.mainCategoryId, required this.paginationParams,required this.userId});
}
