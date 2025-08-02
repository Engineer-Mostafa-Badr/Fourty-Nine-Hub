import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/custom_page/domain/reposiory/custom_page_repository.dart';

import '../entity/custom_page_sub_categories_entity.dart';

class FetchCustomPageSubCategoriesUseCase extends UseCase<List<CustomPageSubCategoriesEntity>, String> {
  final CustomPageRepository _customPageRepository;

  FetchCustomPageSubCategoriesUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, List<CustomPageSubCategoriesEntity>>> call(String mainCategoryId) async {
    return await _customPageRepository.fetchFavouriteSubCat(mainCategoryId);
  }
}
