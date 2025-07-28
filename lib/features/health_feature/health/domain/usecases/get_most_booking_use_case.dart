import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/most_booking_entity.dart';
import '../repositories/health_repo.dart';

class GetMostBookingUseCase extends UseCase<List<MostBookingEntity> , GetMostBookingParams> {
  final HealthRepo _repo;

  GetMostBookingUseCase(this._repo);

  @override
  Future<Either<Failure, List<MostBookingEntity >>> call(GetMostBookingParams params) async {
    return await _repo.getMostBooking(params: params);
  }
}
class GetMostBookingParams {
  final int page;
  final int limit;
  // final String orderBy;

  GetMostBookingParams({
    required this.page,
    required this.limit,
    // required this.orderBy,

  });
  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    // 'orderBy': orderBy,


  };
}