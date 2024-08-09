import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/entities/bidding_entity.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/repositories/auction_details_repo.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';


class GetAuctionRequestsUseCase
    extends UseCase<List<BiddingEntity>, String> {
  final AuctionDetailsRepo _repo;
  GetAuctionRequestsUseCase(this._repo);

  @override
  Future<Either<Failure, List<BiddingEntity>>> call(String params) {
    return _repo.getAuctionRequests(id: params);
  }
}
