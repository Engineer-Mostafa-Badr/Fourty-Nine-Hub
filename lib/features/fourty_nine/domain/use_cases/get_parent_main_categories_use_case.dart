import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/parent_main_category_entity.dart';

import '../repositories/fourty_nine_repository.dart';

class GetParentMainCategoriesUseCase
    extends UseCase<List<ParentMainCategoryEntity>, NoParams> {
  final FourtyNineRepository _fourtyNineRepository;

  GetParentMainCategoriesUseCase(this._fourtyNineRepository);

  @override
  Future<Either<Failure, List<ParentMainCategoryEntity>>> call(
    NoParams params,
  ) {
    return _fourtyNineRepository.getParentMainCategories();
  }
}
