import 'package:dartz/dartz.dart';
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
