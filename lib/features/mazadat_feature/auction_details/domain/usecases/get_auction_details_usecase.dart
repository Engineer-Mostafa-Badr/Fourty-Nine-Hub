import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/repositories/auction_details_repo.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/domain/entities/auction_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetAuctionDetailsUseCase extends UseCase<AuctionEntity, String> {
  final AuctionDetailsRepo _repo;
  GetAuctionDetailsUseCase(this._repo);

  @override
  Future<Either<Failure, AuctionEntity>> call(String params) {
    return _repo.getAuctionDetails(id: params);
  }
}
