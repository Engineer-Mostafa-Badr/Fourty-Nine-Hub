import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/available_trip_join_entity.dart';
import '../repos/view_all_trip_join_repo.dart';
import 'get_car_brand_use_case.dart';

class GetAvailablePickMeUseCase
    extends UseCase<List<AvailableTripJoinEntity>, CarBrandParams> {
  final ViewAllTripJoinRepo _repo;
  GetAvailablePickMeUseCase(this._repo);

  @override
  Future<Either<Failure, List<AvailableTripJoinEntity>>> call(CarBrandParams params) {
    return _repo.getAvailablePickMe(params);
  }
}

class GetAvailablePickMeParams{
  final int page;
  final String? search;
  final int limit;

  GetAvailablePickMeParams({required this.page, required this.limit,this.search});
}