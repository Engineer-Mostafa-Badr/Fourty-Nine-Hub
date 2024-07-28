import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/repositories/auction_details_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';


class EndAuctionUsecase
    extends UseCase<bool, String> {
  final AuctionDetailsRepo _repo;
  EndAuctionUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.finishAuction(id: params);
  }
}
