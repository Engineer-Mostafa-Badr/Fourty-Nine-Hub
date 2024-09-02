import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/subcategories/domain/repositories/subcategories_repo.dart';

class DeleteFavoriteCategoryUseCase extends UseCase<bool, String> {
  final SubcategoriesRepo _repo;

  DeleteFavoriteCategoryUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.deleteFavoriteCategory(params);
  }
}
