import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/auction_all_winner_entity.dart';
import '../repositories/auction_repo.dart';

class GetAllWinnerAuctionUseCase extends UseCase<AuctionWinnerDataEntity , NoParams> {
  final AuctionRepository _repo;

  GetAllWinnerAuctionUseCase(this._repo);

  @override
  Future<Either<Failure, AuctionWinnerDataEntity >> call(NoParams params) async {
    return await _repo.getAllWinnerAuction();
  }
}
