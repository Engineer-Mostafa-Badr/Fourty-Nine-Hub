import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../reposiory/custom_page_repository.dart';

import '../entity/custom_page_categories_entity.dart';

class FetchCustomPageCategoriesUseCase extends UseCase<List<CustomPageCategoriesEntity>, bool> {
  final CustomPageRepository _customPageRepository;

  FetchCustomPageCategoriesUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, List<CustomPageCategoriesEntity>>> call(bool refresh) async {
    return await _customPageRepository.fetchFavouriteCat(refresh);
  }
}
