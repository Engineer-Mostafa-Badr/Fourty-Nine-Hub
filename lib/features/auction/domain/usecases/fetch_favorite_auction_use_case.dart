import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/get_all_auction_entity.dart';
import '../repositories/auction_repo.dart';
import 'fetch_available_auction_use_case.dart';

class GetFavoriteAuctionUseCase extends UseCase<List<GetAvailableAuctionEntity >, GetAuctionParams> {
  final AuctionRepository _repo;

  GetFavoriteAuctionUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetAvailableAuctionEntity >>> call(GetAuctionParams params) async {
    return await _repo.getFavoriteAuction(params:params);
  }
}
