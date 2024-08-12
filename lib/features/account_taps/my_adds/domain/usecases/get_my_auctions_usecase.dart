import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/repositories/my_ads_repo.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/domain/entities/auction_entity.dart';
import '../../../../../../core/abstract/use_case.dart';

class GetMyAuctionsUseCase extends UseCase<List<AuctionEntity>, NoParams> {
  final MyAdsRepo _repo;
  GetMyAuctionsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AuctionEntity>>> call(NoParams params) {
    return _repo.getMyAuctions();
  }
}
