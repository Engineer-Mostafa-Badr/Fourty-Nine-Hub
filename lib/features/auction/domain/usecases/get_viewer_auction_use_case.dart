import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/available_trip_join_entity.dart';


import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repositories/auction_repo.dart';
import 'add_favorite_auction_use_case.dart';

class GetViewerAuctionUseCase extends UseCase<List<ViewerEntity>, FavoriteAuctionParams> {
  final AuctionRepository _repo;

  GetViewerAuctionUseCase(this._repo);
  @override
  Future<Either<Failure, List<ViewerEntity>>> call(FavoriteAuctionParams params) async {
    return await _repo.getViewerAuction(params: params);
  }

}




