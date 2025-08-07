import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/resturant_list_repo.dart';

import '../entities/user_order_entity.dart';

class GetUserOrderUseCase {
  final RestaurantListRepo _repo;
  GetUserOrderUseCase(this._repo);

  Future<Either<Failure, List<UserOrderEntity>>> call(
      {required GetUserOrderParams params}) {
    return _repo.getUserOrder(params: params);
  }
}
class GetUserOrderParams {
  final int page;
  final int limit;

  GetUserOrderParams({
    required this.page,
    required this.limit,

  });
  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,


  };
}
