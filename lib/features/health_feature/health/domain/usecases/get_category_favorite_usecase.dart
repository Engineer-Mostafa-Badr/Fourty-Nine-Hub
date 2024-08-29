import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/favorite_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/health_repo.dart';

class GetCategoryFavoriteUseCase
    extends UseCase<List<FavoriteCategoryBannersEntity>, NoParams> {
  final HealthRepo _repo;
  GetCategoryFavoriteUseCase(this._repo);

  @override
  Future<Either<Failure, List<FavoriteCategoryBannersEntity>>> call(NoParams params) {
    return _repo.getCategoryFavorite();
  }
}
