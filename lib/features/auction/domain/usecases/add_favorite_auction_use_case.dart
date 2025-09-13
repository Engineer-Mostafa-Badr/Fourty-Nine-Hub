import 'package:dartz/dartz.dart';


import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/add_favorite_auction_entity.dart';
import '../repositories/auction_repo.dart';

class AddFavoriteAuctionUseCase extends UseCase<AddFavoriteAuctionEntity , FavoriteAuctionParams> {
  final AuctionRepository _repo;

  AddFavoriteAuctionUseCase(this._repo);
  @override
  Future<Either<Failure, AddFavoriteAuctionEntity >> call(FavoriteAuctionParams params) async {
    return await _repo.addFavoriteAuction(params: params);
  }

}

class FavoriteAuctionParams {
  final String id;

  FavoriteAuctionParams({required this.id});


}



