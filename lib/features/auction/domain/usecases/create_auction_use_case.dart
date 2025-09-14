import 'package:dartz/dartz.dart';


import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/add_favorite_auction_entity.dart';
import '../repositories/auction_repo.dart';

class CreateAuctionUseCase extends UseCase<CreateAuctionEntity , CreateAuctionParams> {
  final AuctionRepository _repo;

  CreateAuctionUseCase(this._repo);
  @override
  Future<Either<Failure, CreateAuctionEntity >> call(CreateAuctionParams params) async {
    return await _repo.createAuction(params: params);
  }

}

class CreateAuctionParams {
  final String mainCategoryId;
  final String subCategoryId;
  final String title;
  final String description;
  final num price;
  final num minBiddingPrice;
  final String startAt; // or DateTime if you want to convert before JSON
  final String endAt;   // same as above
  final List<String> media;

  CreateAuctionParams({
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.minBiddingPrice,
    required this.startAt,
    required this.endAt,
    required this.media,
  });

  Map<String, dynamic> toJson() => {
    'mainCategoryId': mainCategoryId,
    'subCategoryId': subCategoryId,
    'title': title,
    'description': description,
    'price': price,
    'minBiddingPrice': minBiddingPrice,
    'startAt': startAt,
    'endAt': endAt,
    'media': media,
  };
}




