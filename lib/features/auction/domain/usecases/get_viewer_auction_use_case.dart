import 'package:dartz/dartz.dart';


import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/add_favorite_auction_entity.dart';
import '../entities/auction_viewer_entity.dart';
import '../repositories/auction_repo.dart';
import 'add_favorite_auction_use_case.dart';

class GetViewerAuctionUseCase extends UseCase<List<AuctionViewerEntity>, FavoriteAuctionParams> {
  final AuctionRepository _repo;

  GetViewerAuctionUseCase(this._repo);
  @override
  Future<Either<Failure, List<AuctionViewerEntity>>> call(FavoriteAuctionParams params) async {
    return await _repo.getViewerAuction(params: params);
  }

}




