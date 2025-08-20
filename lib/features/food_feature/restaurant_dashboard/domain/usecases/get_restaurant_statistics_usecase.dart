import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../presentation/cubit/restaurant_statistics_cubit.dart';

import '../repositories/restaurant_dashboard_repo.dart';

class GetRestaurantStatisticUseCase
    extends UseCase<RestaurantStatistics, NoParams> {
  final RestaurantDashboardRepo _repository;

  const GetRestaurantStatisticUseCase(this._repository);

  @override
  Future<Either<Failure, RestaurantStatistics>> call(NoParams params) {
    return _repository.getRestaurantStatistics();
  }
}
