import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class GetDoctorAppointmentsByDayUseCase extends UseCase<
    List<DoctorAppointmentEntity>, GetDoctorAppointmentsByDayParams> {
  final DoctorDashboardRepo doctorDashboardRepo;

  GetDoctorAppointmentsByDayUseCase(this.doctorDashboardRepo);

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>> call(
      GetDoctorAppointmentsByDayParams params) {
    return doctorDashboardRepo.getDoctorAppointmentsByDay(params);
  }
}

class GetDoctorAppointmentsByDayParams {
  WeekDays day;
  PaginationParams paginationParams;

  GetDoctorAppointmentsByDayParams(
      {required this.day, required this.paginationParams});

  Map<String, dynamic> toJson() {
    print("day.name.toLowerCase()${day.name.toLowerCase()}");
    return {
        "day": day.name.toLowerCase(),
      };
  }
}
