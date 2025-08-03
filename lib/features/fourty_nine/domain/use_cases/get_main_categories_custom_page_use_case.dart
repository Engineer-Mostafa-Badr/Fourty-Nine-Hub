import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/main_category_entity.dart';
import 'get_main_categories_use_case.dart';

import '../repositories/fourty_nine_repository.dart';

class GetMainCategoriesCustomPageUseCase
    extends UseCase<List<MainCategoryEntity>, MainCategoriesParams> {
  final FourtyNineRepository _fourtyNineRepository;

  GetMainCategoriesCustomPageUseCase(this._fourtyNineRepository);

  @override
  Future<Either<Failure, List<MainCategoryEntity>>> call(
    MainCategoriesParams params,
  ) {
    return _fourtyNineRepository.getMainCategoriesCustomPage(params);
  }
}
