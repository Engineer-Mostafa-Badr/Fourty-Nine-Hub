import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/repositories/my_ads_repo.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../entity/get_all_counts_trip_join_entity.dart';

class GetAllCountsUseCase extends UseCase<List<GetAllCountsTripJoinEntity>, Params> {
  final MyAdsRepo _repo;
  GetAllCountsUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetAllCountsTripJoinEntity>>> call(Params params) {
    return _repo.getAllCountsTripJoin(params);
  }
}


class Params {
  final String id;
  final String status;

  Params({required this.id, required this.status});
}