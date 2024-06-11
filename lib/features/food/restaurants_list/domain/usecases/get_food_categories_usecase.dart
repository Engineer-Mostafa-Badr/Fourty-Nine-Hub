import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food/restaurants_list/data/models/food_category_model.dart';
import 'package:fourtyninehub/features/food/restaurants_list/data/repositories/restaurant_list_repo_impl.dart';
import '../../../../../../core/abstract/use_case.dart';

class GetFoodCategoriesUseCase
    extends UseCase<List<FoodCategoryModel>, NoParams> {
  final RestaurantListRepoImpl _repo;
  GetFoodCategoriesUseCase(this._repo);

  @override
  Future<Either<Failure, List<FoodCategoryModel>>> call(NoParams params) {
    return _repo.getFoodCategories();
  }
}
