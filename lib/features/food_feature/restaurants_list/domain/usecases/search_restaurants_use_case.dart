import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/restaurant.dart';
import '../repositories/restaurant_list_repo.dart';
import '../../../../social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';

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
