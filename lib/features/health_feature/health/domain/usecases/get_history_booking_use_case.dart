import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_booking_use_case.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/booking_entity.dart';
import '../repositories/health_repo.dart';

class GetHistoryBookingUseCase extends UseCase<List<BookingEntity > , GetBookingParams> {
  final HealthRepo _repo;

  GetHistoryBookingUseCase(this._repo);

  @override
  Future<Either<Failure, List<BookingEntity>>> call(GetBookingParams params) async {
    return await _repo.getHistoryBooking(params: params);
  }
}