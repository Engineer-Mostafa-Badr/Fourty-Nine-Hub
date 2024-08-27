import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';

class GetMealCategoriesWithCountRestaurantsUseCase {
  final RestaurantListRepo _repo;

  GetMealCategoriesWithCountRestaurantsUseCase(this._repo);

  Future<Either<Failure, List<FoodCategoryEntity>>> call(
      {required PostCommentsParams params}) async {
    return _repo.getMealCategoriesWithCountRestaurants(params: params);
  }
}
