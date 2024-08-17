import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_category_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/account_repo.dart';

class GetFavouriteCategoriesUseCase
    extends UseCase<List<FavouriteCategoryEntity>, NoParams> {
  final AccountRepo _repo;
  GetFavouriteCategoriesUseCase(this._repo);
  @override
  Future<Either<Failure, List<FavouriteCategoryEntity>>> call(NoParams params) {
    return _repo.getFavouriteCategories();
  }
}
