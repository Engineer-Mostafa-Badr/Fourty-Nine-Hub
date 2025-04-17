import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/booking_entity.dart';
import '../repositories/health_repo.dart';

class GetBookingUseCase extends UseCase<List<BookingEntity > , GetBookingParams> {
  final HealthRepo _repo;

  GetBookingUseCase(this._repo);

  @override
  Future<Either<Failure, List<BookingEntity>>> call(GetBookingParams params) async {
    return await _repo.getBooking(params: params);
  }
}
class GetBookingParams {
  final int page;
  final int limit;
  final String type;

  GetBookingParams({
    required this.page,
    required this.limit,
    required this.type,

  });
  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'type': type,


  };
}