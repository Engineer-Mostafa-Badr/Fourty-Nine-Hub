import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/custom_page/domain/reposiory/custom_page_repository.dart';

import '../entity/favourite_categ_entity.dart';
import '../entity/navigate_bar_entity.dart';

class FetchFavouriteCatUseCase extends UseCase<FavouriteCatEntity,NoParams>{
  final CustomPageRepository _customPageRepository;

  FetchFavouriteCatUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, FavouriteCatEntity>> call(NoParams params)async {
    return await _customPageRepository.fetchFavouriteCat();
  }
}