import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';

class AddTinderFavouriteCategoryUseCase extends UseCase<bool, String> {
  final TinderRepository _repository;

  AddTinderFavouriteCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repository.addFavouriteCategories(params);
  }
}
