import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../reposiory/custom_page_repository.dart';

import '../entity/custom_page_sub_categories_entity.dart';

class FetchCustomPageSubCategoriesUseCase extends UseCase<List<CustomPageSubCategoriesEntity>, String> {
  final CustomPageRepository _customPageRepository;

  FetchCustomPageSubCategoriesUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, List<CustomPageSubCategoriesEntity>>> call(String mainCategoryId) async {
    return await _customPageRepository.fetchFavouriteSubCat(mainCategoryId);
  }
}
