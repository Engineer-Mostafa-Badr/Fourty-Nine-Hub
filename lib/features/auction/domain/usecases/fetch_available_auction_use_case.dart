import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/get_all_auction_entity.dart';
import '../repositories/auction_repo.dart';

class GetAvailableAuctionUseCase extends UseCase<List<GetAvailableAuctionEntity >, GetAuctionParams> {
  final AuctionRepository _repo;

  GetAvailableAuctionUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetAvailableAuctionEntity >>> call(GetAuctionParams params) async {
    return await _repo.getAvailableAuction(params:params);
  }
}
class GetAuctionParams{
  final int page;
  final int limit;

  GetAuctionParams({required this.page, required this.limit});

  Map<String,dynamic>toJson()=>{
    "page":page,
    "limit":limit
  };

}
