import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/repositories/auction_details_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';


class FollowUsersAuctionUseCase
    extends UseCase<bool, int> {
  final AuctionDetailsRepo _repo;
  FollowUsersAuctionUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(int params) {
    return _repo.followUserAuctions(userId: params);
  }
}
