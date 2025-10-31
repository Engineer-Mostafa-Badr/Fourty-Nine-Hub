import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/repositories/doctor_details_repo.dart';

class GetBookingDoctorByIdUseCase
    extends UseCase<DoctorEntity, GetBookingDoctorByIdParams> {
  final DoctorDetailsRepo _repo;
  GetBookingDoctorByIdUseCase(this._repo);

  @override
  Future<Either<Failure, DoctorEntity>> call(
      GetBookingDoctorByIdParams params) {
    return _repo.getBookingDoctorById(doctorId: params.doctorId);
  }
}

class GetBookingDoctorByIdParams {
  final String doctorId;
  GetBookingDoctorByIdParams({required this.doctorId});
}
