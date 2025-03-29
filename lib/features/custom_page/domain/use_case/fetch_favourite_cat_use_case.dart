import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/custom_page/domain/reposiory/custom_page_repository.dart';

import '../entity/custom_page_categories_entity.dart';

class FetchCustomPageCategoriesUseCase extends UseCase<List<CustomPageCategoriesEntity>, bool> {
  final CustomPageRepository _customPageRepository;

  FetchCustomPageCategoriesUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, List<CustomPageCategoriesEntity>>> call(bool refresh) async {
    return await _customPageRepository.fetchFavouriteCat(refresh);
  }
}
