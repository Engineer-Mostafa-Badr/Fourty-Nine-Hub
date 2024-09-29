import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/my_ads_trip_join_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/repositories/my_ads_repo.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../entity/my_ads_auction.dart';

class GetMyTripJoinUseCase extends UseCase<MyAdsTripJoinEntity, NoParams> {
  final MyAdsRepo _repo;
  GetMyTripJoinUseCase(this._repo);

  @override
  Future<Either<Failure, MyAdsTripJoinEntity>> call(NoParams params) {
    return _repo.getMyTripJoin();
  }
}
