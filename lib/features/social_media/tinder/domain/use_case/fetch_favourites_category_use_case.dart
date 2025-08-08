import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/get_fav_category_model.dart';
import '../repositories/tinder_repository.dart';

class GetTinderFavouritesCategoryUseCase
    extends UseCase<CategoryFavoritesResponse, NoParams> {
  final TinderRepository _repository;

  GetTinderFavouritesCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, CategoryFavoritesResponse>> call(NoParams params) {
    return _repository.fetchFavouritesCategories();
  }
}
