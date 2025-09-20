import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_most_booking_use_case.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/most_booking_entity.dart';
import '../repositories/health_repo.dart';

class GetUserBookingUseCase extends UseCase<List<BookedAppointmentEntity> , GetMostBookingParams> {
  final HealthRepo _repo;

  GetUserBookingUseCase(this._repo);

  @override
  Future<Either<Failure, List<BookedAppointmentEntity >>> call(GetMostBookingParams params) async {
    return await _repo.getUserBooking(params: params);
  }
}
