import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/main_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/repository/chance_repository.dart';

class MainCategoryChanceUseCase
    extends UseCase<List<MainCategoryDropEntity>, MainCategoryChanceParams> {
  final ChanceRepository _chanceRepository;

  MainCategoryChanceUseCase(this._chanceRepository);

  @override
  Future<Either<Failure, List<MainCategoryDropEntity>>> call(
      MainCategoryChanceParams params) async {
    return await _chanceRepository.fetchMainCategory(params);
  }
}

class MainCategoryChanceParams {
  PaginationParams paginationParams;

  MainCategoryChanceParams({required this.paginationParams});
}
