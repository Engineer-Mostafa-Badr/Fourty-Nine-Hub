import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';

class SearchRestaurantsUseCase {
  final RestaurantListRepo _repo;
  SearchRestaurantsUseCase(this._repo);

  Future<Either<Failure, List<GetAllRestaurantEntity>>> call(
      {required String city,
      required String subCategory,
      required String government,
      PostCommentsParams? params}) {
    return _repo.searchRestaurants(
      city: city,
      government: government,
      subCategory: subCategory,
      params: params,
    );
  }
}
