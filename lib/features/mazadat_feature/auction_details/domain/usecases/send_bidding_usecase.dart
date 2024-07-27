import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/repositories/auction_details_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class SendBiddingUseCase extends UseCase<bool, SendBiddingParams> {
  final AuctionDetailsRepo _repo;
  SendBiddingUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(SendBiddingParams params) {
    return _repo.sendAuction(params: params);
  }
}

class SendBiddingParams {
  final String auctionId;
  final num price;
  SendBiddingParams({required this.auctionId, required this.price});
  Map<String, dynamic> toJson() => {"price": price};
}
