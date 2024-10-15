import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_drawer_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/account_repo.dart';

class DeleteFavouriteAdsUsecase
    extends UseCase<bool, String> {
  final AccountRepo _repo;
  DeleteFavouriteAdsUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params)async {
   return await _repo.deleteFavouriteAds(id: params);
  }

}
