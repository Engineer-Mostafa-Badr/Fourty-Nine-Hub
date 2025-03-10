import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/ride_request_repo.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../subcategories/data/models/sub_category_model.dart';

class GetSubCategoriesUseCase extends UseCase<List<SubCategoryModel>, String> {
  final RideRequestRepo _repo;
  GetSubCategoriesUseCase(this._repo);

  @override
  Future<Either<Failure, List<SubCategoryModel>>> call(String params) {
    return _repo.getSubCategories(mainCategoryId: params);
  }
}
