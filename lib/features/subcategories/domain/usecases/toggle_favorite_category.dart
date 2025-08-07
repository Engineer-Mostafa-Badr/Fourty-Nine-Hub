import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repositories/subcategories_repo.dart';

class ToggleFavoriteCategoryUseCase extends UseCase<bool, String> {
  final SubcategoriesRepo _repo;

  ToggleFavoriteCategoryUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.toggleFavoriteCategory(params);
  }
}
