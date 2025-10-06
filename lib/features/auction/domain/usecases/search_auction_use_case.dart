import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/get_all_auction_entity.dart';
import '../repositories/auction_repo.dart';

class SearchAuctionUseCase extends UseCase<List<GetAvailableAuctionEntity >, SearchAuctionParams> {
  final AuctionRepository _repo;

  SearchAuctionUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetAvailableAuctionEntity>>> call(SearchAuctionParams params) async {
    return await _repo.searchAuction(params:params);
  }
}
class SearchAuctionParams{
  final int page;
  final int limit;
  final String searchQuery;

  SearchAuctionParams({required this.page, required this.limit,required this.searchQuery});

  Map<String,dynamic>toJson()=>{
    "page":page,
    "limit":limit
  };

}
