import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

import '../../../restaurants_list/domain/entities/restaurant.dart';
import '../repositories/restaurant_dashboard_repo.dart';

class GetRestaurantInfoUseCase extends UseCase<GetAllRestaurantEntity, NoParams> {
  final RestaurantDashboardRepo _repository;

  const GetRestaurantInfoUseCase(this._repository);

  @override
  Future<Either<Failure, GetAllRestaurantEntity>> call(NoParams params) {
    return _repository.getRestaurantInfo();
  }
}
