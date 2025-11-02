import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/auction_sub_category_entity.dart';
import '../repositories/auction_repo.dart';

class GetAuctionSubCategoryUseCase extends UseCase<List<AuctionSubCategoryEntity >, GetSubCategoryAuctionParams> {
  final AuctionRepository _repo;

  GetAuctionSubCategoryUseCase(this._repo);

  @override
  Future<Either<Failure, List<AuctionSubCategoryEntity >>> call(GetSubCategoryAuctionParams params) async {
    return await _repo.getAuctionSubCategory(params:params);
  }
}
class GetSubCategoryAuctionParams{
  final int page;
  final int limit;
  final String id;

  GetSubCategoryAuctionParams({required this.page, required this.limit,required this.id});

  Map<String,dynamic>toJson()=>{
    "page":page,
    "limit":limit
  };

}
