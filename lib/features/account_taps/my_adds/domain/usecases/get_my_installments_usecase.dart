import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/repositories/my_ads_repo.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../entity/my_ads_auction.dart';

class GetMyInstallmentUseCase
    extends UseCase<List<MyAuctionAdsEntity>, NoParams> {
  final MyAdsRepo _repo;
  GetMyInstallmentUseCase(this._repo);

  @override
  Future<Either<Failure, List<MyAuctionAdsEntity>>> call(NoParams params) {
    return _repo.getMyInstallments();
  }
}
