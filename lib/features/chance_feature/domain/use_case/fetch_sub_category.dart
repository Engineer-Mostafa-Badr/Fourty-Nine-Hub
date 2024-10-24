import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/sub_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/repository/chance_repository.dart';

class SubCategoryChanceUseCase
    extends UseCase<List<SubCategoryDropEntity>, SubCategoryChanceParams> {
  final ChanceRepository _chanceRepository;

  SubCategoryChanceUseCase(this._chanceRepository);

  @override
  Future<Either<Failure, List<SubCategoryDropEntity>>> call(
      SubCategoryChanceParams params) async {
    return await _chanceRepository.fetchSubCategory(params);
  }
}

class SubCategoryChanceParams {
  String? id;
  PaginationParams paginationParams;

  SubCategoryChanceParams({required this.paginationParams, this.id});
}
