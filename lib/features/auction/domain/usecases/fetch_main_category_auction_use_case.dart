import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/auction_main_category_entity.dart';
import '../entities/get_all_auction_entity.dart';
import '../repositories/auction_repo.dart';
import 'fetch_available_auction_use_case.dart';

class GetAuctionMainCategoryUseCase extends UseCase<List<AuctionMainCategoryEntity >, GetAuctionParams> {
  final AuctionRepository _repo;

  GetAuctionMainCategoryUseCase(this._repo);

  @override
  Future<Either<Failure, List<AuctionMainCategoryEntity >>> call(GetAuctionParams params) async {
    return await _repo.getAuctionMainCategory(params:params);
  }
}
