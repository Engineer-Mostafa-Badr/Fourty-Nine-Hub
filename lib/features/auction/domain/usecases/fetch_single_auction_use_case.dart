import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/get_all_auction_entity.dart';
import '../repositories/auction_repo.dart';

class GetSingleAuctionUseCase extends UseCase<GetAvailableAuctionEntity, SingleAuctionParams> {
  final AuctionRepository _repo;

  GetSingleAuctionUseCase(this._repo);

  @override
  Future<Either<Failure, GetAvailableAuctionEntity>> call(SingleAuctionParams params) async {
    return await _repo.getSingleAuction(params:params);
  }
}
class SingleAuctionParams{
  final String id;

  SingleAuctionParams({required this.id});
}