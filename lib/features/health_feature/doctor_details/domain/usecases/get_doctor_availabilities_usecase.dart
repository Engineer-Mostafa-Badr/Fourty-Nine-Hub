import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/repositories/doctor_details_repo.dart';

class GetDoctorAvailabilitiesUseCase
    extends UseCase<List<AppointmentEntity>, GetDoctorAvailabilitiesParams> {
  final DoctorDetailsRepo _repo;
  GetDoctorAvailabilitiesUseCase(this._repo);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(
      GetDoctorAvailabilitiesParams params) {
    return _repo.getDoctorAvailabilities(
      doctorId: params.doctorId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetDoctorAvailabilitiesParams {
  final String doctorId;
  final int page;
  final int limit;
  GetDoctorAvailabilitiesParams({
    required this.doctorId,
    this.page = 1,
    this.limit = 100,
  });
}
