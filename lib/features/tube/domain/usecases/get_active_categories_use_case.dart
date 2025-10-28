import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/tube/domain/entities/get_active_category_entity.dart';
import 'package:fourtyninehub/features/tube/domain/repositories/tube_repo.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';


class GetActiveCategoriesUseCase extends UseCase<ActiveCategoryResponseEntity, NoParams> {
  final TubeRepository _starRepository;

  GetActiveCategoriesUseCase(this._starRepository);

  @override
  Future<Either<Failure, ActiveCategoryResponseEntity>> call(NoParams params) async {
    return await _starRepository.getActiveCategories();
  }
}