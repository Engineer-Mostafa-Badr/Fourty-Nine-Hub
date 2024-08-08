import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class GetAllDoctorReservationsUsecase
    extends UseCase<List<DoctorAppointmentEntity>, PaginationParams> {
  final DoctorDashboardRepo _repo;

  GetAllDoctorReservationsUsecase(this._repo);

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>> call(
      PaginationParams params) {
    return _repo.getAllReservations(params);
  }
}
