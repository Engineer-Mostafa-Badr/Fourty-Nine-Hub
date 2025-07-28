import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/favourite_subcategory_entity.dart';
import '../repositories/account_repo.dart';

class GetFavouriteSubCategoriesUseCase
    extends UseCase<List<FavouriteSubcategoryEntity>, NoParams> {
  final AccountRepo _repo;
  GetFavouriteSubCategoriesUseCase(this._repo);
  @override
  Future<Either<Failure, List<FavouriteSubcategoryEntity>>> call(NoParams params) {
    return _repo.getFavouriteSubcategories();
  }
}
