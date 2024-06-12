import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../data/models/food_category_model.dart';
import '../repositories/resturant_list_repo.dart';

class GetFoodCategoriesUseCase
    extends UseCase<List<FoodCategoryModel>, NoParams> {
  final RestaurantListRepo _repo;
  GetFoodCategoriesUseCase(this._repo);

  @override
  Future<Either<Failure, List<FoodCategoryModel>>> call(NoParams params) {
    return _repo.getFoodCategories();
  }
}
