import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';

class GetTinderFavouritesUseCase
    extends UseCase<SubFavoritesResponse, NoParams> {
  final TinderRepository _repository;

  GetTinderFavouritesUseCase(this._repository);

  @override
  Future<Either<Failure, SubFavoritesResponse>> call(NoParams params) {
    return _repository.fetchFavourites();
  }
}
