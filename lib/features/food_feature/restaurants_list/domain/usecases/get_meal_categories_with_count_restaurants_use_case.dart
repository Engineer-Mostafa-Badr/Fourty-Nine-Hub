import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/food_category_entity.dart';
import '../repositories/restaurant_list_repo.dart';
import '../../../../social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';

class GetMealCategoriesWithCountRestaurantsUseCase {
  final RestaurantListRepo _repo;

  GetMealCategoriesWithCountRestaurantsUseCase(this._repo);

  Future<Either<Failure, List<FoodCategoryEntity>>> call(
      {required PostCommentsParams params}) async {
    return _repo.getMealCategoriesWithCountRestaurants(params: params);
  }
}
