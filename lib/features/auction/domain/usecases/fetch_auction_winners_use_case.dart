import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/all_winner_auction_entity.dart';
import '../repositories/auction_repo.dart';
import 'fetch_available_auction_use_case.dart';

class GetAuctionWinnersUseCase extends UseCase<List<AuctionAllWinnerEntity   >, GetAuctionParams> {
  final AuctionRepository _repo;

  GetAuctionWinnersUseCase(this._repo);

  @override
  Future<Either<Failure, List<AuctionAllWinnerEntity   >>> call(GetAuctionParams params) async {
    return await _repo.getAuctionWinners(params:params);
  }
}
