import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/repositories/fourty_nine_repository.dart';

class AddMainCategoryToFavoritesUseCase extends UseCase<bool, String> {
  final FourtyNineRepository _repo;

  AddMainCategoryToFavoritesUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.addMainCategoryToFavorites(params);
  }
}
