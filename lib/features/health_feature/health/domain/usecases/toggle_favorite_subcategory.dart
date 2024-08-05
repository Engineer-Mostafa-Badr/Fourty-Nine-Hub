import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/repositories/health_repo.dart';

class ToggleFavoriteSubcategoryUseCase extends UseCase<bool,String> {

  final HealthRepo _healthRepo;

  ToggleFavoriteSubcategoryUseCase(this._healthRepo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _healthRepo.toggleFavoriteSubcategory(params);
  }
}