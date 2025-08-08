import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repositories/subcategories_repo.dart';

class ToggleFavoriteSubcategoryUseCase extends UseCase<bool, String> {
  final SubcategoriesRepo _repo;

  ToggleFavoriteSubcategoryUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.toggleFavoriteSubcategory(params);
  }
}
