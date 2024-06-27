import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/appointment_entity.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../repositories/book_doctor_appointment_repo.dart';

class GetDoctorAppointmentsUseCase
    extends UseCase<List<AppointmentEntity>, DateTime> {
  final BookAppointmentRepo _repo;
  GetDoctorAppointmentsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(DateTime params) {
    return  _repo.getDoctorAppointments(date: params);
  }
}
