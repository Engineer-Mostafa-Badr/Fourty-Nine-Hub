import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repositories/fourty_nine_repository.dart';

class RemoveMainCategoryFromFavoritesUseCase extends UseCase<bool, String> {
  final FourtyNineRepository _repo;

  RemoveMainCategoryFromFavoritesUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.removeMainCategoryFromFavorites(params);
  }
}
