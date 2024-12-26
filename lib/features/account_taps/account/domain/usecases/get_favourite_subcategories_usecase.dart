import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/account_repo.dart';

class GetFavouriteSubCategoriesUseCase
    extends UseCase<List<SubCategoryEntity>, NoParams> {
  final AccountRepo _repo;
  GetFavouriteSubCategoriesUseCase(this._repo);
  @override
  Future<Either<Failure, List<SubCategoryEntity>>> call(NoParams params) {
    return _repo.getFavouriteSubcategories();
  }
}
