import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class UpdateDoctorPersonalInfoUsecase
    extends UseCase<bool, DoctorPersonalInfoParams> {
  final DoctorDashboardRepo _repo;

  UpdateDoctorPersonalInfoUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(params) {
    return _repo.updatePersonalInfo(params);
  }
}

class DoctorPersonalInfoParams {
  final String governorateId;
  final String address;
  final String cityId;
  final String phone;
  final String subCategoryId;
  final String lastName;
  final String firstName;

  DoctorPersonalInfoParams({required this.governorateId, required this.address, required this.cityId, required this.phone, required this.subCategoryId, required this.lastName, required this.firstName});

  //toJson
  Map<String, dynamic> toJson() => {
    'governorateId': governorateId,
    'address': address, 'cityId': cityId,
    'phone': phone,
    'subCategoryId': subCategoryId,
    'lastName': lastName,
    'firstName': firstName,
  };
}
