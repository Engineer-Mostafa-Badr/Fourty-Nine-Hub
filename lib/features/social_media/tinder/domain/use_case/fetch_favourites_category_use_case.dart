import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';

import '../../data/models/tinder_person_model.dart';


class GetTinderFavouritesCategoryUseCase extends UseCase<CategoryFavoritesResponse, NoParams> {
  final TinderRepository _repository;

  GetTinderFavouritesCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, CategoryFavoritesResponse>> call(NoParams params) {
    return _repository.fetchFavouritesCategories();
  }
}

