import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class GetDoctorUnhandledAppointmentsUseCase extends UseCase<
    List<DoctorAppointmentEntity>, GetDoctorUnhandledAppointmentsParams> {
  final DoctorDashboardRepo _repo;

  GetDoctorUnhandledAppointmentsUseCase(this._repo);

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>> call(
      GetDoctorUnhandledAppointmentsParams params) {
    return _repo.getDoctorUnhandledAppointments(params);
  }
}

class GetDoctorUnhandledAppointmentsParams {
  int page;
  int limit;
  GetDoctorUnhandledAppointmentsParams(
      {required this.page, required this.limit});

  Map<String, dynamic> get queryParams => {"page": page, "limit": limit};
}
