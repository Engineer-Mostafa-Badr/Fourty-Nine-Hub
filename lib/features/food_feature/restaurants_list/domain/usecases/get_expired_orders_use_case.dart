import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/expired_requests_model.dart';
import '../repositories/restaurant_list_repo.dart';

class GetExpiredOrdersUseCase {
  final RestaurantListRepo _repo;
  GetExpiredOrdersUseCase(this._repo);

  Future<Either<Failure, ExpiredRequestsResponse>> call(
      {required PaginationParams params}) {
    return _repo.getExpiredOrders(params);
  }
}
