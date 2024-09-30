import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';

import '../../data/models/restaurant_2_model.dart';

class GetAllRestaurantUseCase {
  final RestaurantListRepo _repo;
  GetAllRestaurantUseCase(this._repo);

  Future<Either<Failure, List<Restaurant2Model>>> call(
      {required PostCommentsParams params}) {
    return _repo.getAllRestaurantsWithMenu(params: params);
  }
}
