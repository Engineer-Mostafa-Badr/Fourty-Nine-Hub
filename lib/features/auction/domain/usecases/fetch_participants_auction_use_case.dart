import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/auction_participants_entity.dart';
import '../entities/get_all_auction_entity.dart';
import '../repositories/auction_repo.dart';
import 'fetch_single_auction_use_case.dart';

class GetParticipantsAuctionUseCase extends UseCase<List<AuctionParticipantsEntity> , PriceAuctionParams> {
  final AuctionRepository _repo;

  GetParticipantsAuctionUseCase(this._repo);

  @override
  Future<Either<Failure, List<AuctionParticipantsEntity>>> call(PriceAuctionParams params) async {
    return await _repo.getParticipantsAuction(params:params);
  }
}
class PriceAuctionParams {
  final String id;
  final int page;
  final int limit;

  PriceAuctionParams({
    required this.id,
    required this.page,
    required this.limit,
  });
}
