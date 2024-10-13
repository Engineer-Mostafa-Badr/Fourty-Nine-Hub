import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_drawer_entity.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/account_repo.dart';

class GetDrawerFavouriteAdsUsecase
    extends UseCase<List<FavouriteAdDrawerEntity>, NoParams> {
  final AccountRepo _repo;
  GetDrawerFavouriteAdsUsecase(this._repo);
  @override
  Future<Either<Failure, List<FavouriteAdDrawerEntity>>> call(NoParams params) {
    return _repo.getDrawerFavouriteAds();
  }
}
