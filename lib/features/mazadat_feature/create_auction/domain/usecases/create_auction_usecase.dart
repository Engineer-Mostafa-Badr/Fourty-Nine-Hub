import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/mazadat_feature/create_auction/domain/repositories/create_auction_repo.dart';

class CreateAuctionUseCase extends UseCase<bool, CreateAuctionParams> {
  final CreateAuctionRepo _repo;

  CreateAuctionUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(
    CreateAuctionParams params,
  ) {
    return _repo.createAuction(params: params);
  }
}

class CreateAuctionParams {
  final String startPrice;
  final String minimumIncrease;
  final String description;
  final String adId;
  CreateAuctionParams(
      {required this.adId,
      required this.startPrice,
      required this.minimumIncrease,
      required this.description});
  Map<String, dynamic> toJson() => {
        "name": description,
        "start_price": startPrice,
        "small_price": minimumIncrease
      };
}
