import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/account_repo.dart';

class GetFavouriteAdsUsecase
    extends UseCase<List<FavouriteAdEntity>, NoParams> {
  final AccountRepo _repo;
  GetFavouriteAdsUsecase(this._repo);
  @override
  Future<Either<Failure, List<FavouriteAdEntity>>> call(NoParams params) {
    return _repo.getFavouriteAds();
  }
}
