import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/favouite_category_model/favouite_category_model.dart';
import '../repositories/account_repo.dart';

class GetFavouriteCategoriesUseCase
    extends UseCase<List<FavouriteCategoryModel>, NoParams> {
  final AccountRepo _repo;
  GetFavouriteCategoriesUseCase(this._repo);
  @override
  Future<Either<Failure, List<FavouriteCategoryModel>>> call(NoParams params) {
    return _repo.getFavouriteCategories();
  }
}
