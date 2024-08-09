import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/repositories/doctor_details_repo.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import '../../../../../../core/abstract/use_case.dart';

class GetDoctorDetailsUseCase extends UseCase<DoctorEntity, GetDoctorDetailsParams> {
  final DoctorDetailsRepo _repo;
  GetDoctorDetailsUseCase(this._repo);

  @override
  Future<Either<Failure, DoctorEntity>> call(params) {
    return _repo.getDoctorDetails(params);
  }
}

class GetDoctorDetailsParams {
  final String doctorId;
  final String subCategoryId;
  final BookingTypes bookingType;
  GetDoctorDetailsParams({
    required this.doctorId,
    required this.subCategoryId,
    required this.bookingType,
  });

  Map<String, dynamic> toJson() => {
        'subCategoryId': subCategoryId,
        'type': bookingType.name,
      };
}
