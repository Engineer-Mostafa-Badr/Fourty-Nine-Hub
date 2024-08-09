import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/repositories/book_doctor_appointment_repo.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/book_regular_appointment.dart';

class BookPremiumAppointmentUseCase
    extends UseCase<bool, BookAppointmentParams> {
  final BookAppointmentRepo _repo;
  BookPremiumAppointmentUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(params) {
    return _repo.bookPremiumAppointment(params);
  }
}
