import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';

import '../repositories/fourty_nine_repository.dart';

class GetMainCategoriesUseCase
    extends UseCase<List<MainCategoryEntity>, NoParams> {
  final FourtyNineRepository _fourtyNineRepository;

  GetMainCategoriesUseCase(this._fourtyNineRepository);

  @override
  Future<Either<Failure, List<MainCategoryEntity>>> call(
    NoParams params,
  ) {
    return _fourtyNineRepository.getMainCategories();
  }
}
