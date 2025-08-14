import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/get_fav_sub_category_model.dart';
import '../repositories/tinder_repository.dart';

class GetTinderFavouritesUseCase
    extends UseCase<SubFavoritesResponse, NoParams> {
  final TinderRepository _repository;

  GetTinderFavouritesUseCase(this._repository);

  @override
  Future<Either<Failure, SubFavoritesResponse>> call(NoParams params) {
    return _repository.fetchFavourites();
  }
}
