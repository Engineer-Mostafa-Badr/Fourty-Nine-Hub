import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/tinder_repository.dart';

class AddTinderFavouriteCategoryUseCase extends UseCase<bool, String> {
  final TinderRepository _repository;

  AddTinderFavouriteCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repository.addFavouriteCategories(params);
  }
}
