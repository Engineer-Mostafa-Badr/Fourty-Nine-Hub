import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../subcategories/data/models/sub_category_model.dart';
import '../repositories/create_shipping_repo.dart';

class GetShippingSubCategoriesUseCase
    extends UseCase<List<SubCategoryModel>, String> {
  final CreateShippingRepo _repo;
  GetShippingSubCategoriesUseCase(this._repo);

  @override
  Future<Either<Failure, List<SubCategoryModel>>> call(String params) {
    return _repo.getSubCategories(mainCategoryId: params);
  }
}
