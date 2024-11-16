import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/repositories/doctor_details_repo.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import '../../../../../../core/abstract/use_case.dart';

class GetDoctorDetailsIdUseCase
    extends UseCase<DoctorEntity, GetDoctorDetailsIdParams> {
  final DoctorDetailsRepo _repo;
  GetDoctorDetailsIdUseCase(this._repo);

  @override
  Future<Either<Failure, DoctorEntity>> call(params) {
    return _repo.getDoctorDetailsId(params);
  }
}

class GetDoctorDetailsIdParams {
  final String doctorId;
  final String subCategoryId;
  GetDoctorDetailsIdParams({
    required this.doctorId,
    required this.subCategoryId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subCategoryId'] = subCategoryId;
    return data;
  }
}
