import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';

import '../../../../common/models/public/pagination_params.dart';
import '../repositories/fourty_nine_repository.dart';

class GetMainCategoriesUseCase
    extends UseCase<List<MainCategoryEntity>, PaginationParams> {
  final FourtyNineRepository _fourtyNineRepository;

  GetMainCategoriesUseCase(this._fourtyNineRepository);

  @override
  Future<Either<Failure, List<MainCategoryEntity>>> call(
    PaginationParams params,
  ) {
    return _fourtyNineRepository.getMainCategories(params: params);
  }
}
