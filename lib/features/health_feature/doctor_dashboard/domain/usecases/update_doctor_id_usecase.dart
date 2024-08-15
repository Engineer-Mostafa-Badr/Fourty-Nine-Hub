import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class UpdateDoctorIDUsecase extends UseCase<bool, DoctorDocsParams> {
  final DoctorDashboardRepo _repo;

  UpdateDoctorIDUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(params) {
    return _repo.updateID(params);
  }
}

class DoctorDocsParams {
  String frontImageId;
  String backImageId;
  DateTime expireDate;

  DoctorDocsParams(
      {required this.frontImageId,
      required this.backImageId,
      required this.expireDate});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    return data;
  }
}
