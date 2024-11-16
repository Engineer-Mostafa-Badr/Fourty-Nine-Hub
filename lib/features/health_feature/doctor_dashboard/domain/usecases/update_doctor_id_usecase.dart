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
  final String frontImageId;
  final String backImageId;
  final DateTime expireDate;
  final String from;

  DoctorDocsParams({required this.frontImageId, required this.backImageId, required this.expireDate,required this.from});
  /*
  idExpiryDate
idBehindKey
idFrontKey
   */
  //toJson
  Map<String, dynamic> toJson() => from=='id'?{
        'idFrontKey': frontImageId,
        'idBehindKey': backImageId,
        'idExpiryDate': expireDate.toIso8601String(),
      }:{
        'practicingFront': frontImageId,
        'practicingBehind': backImageId,
    'practicingExpiryDate': expireDate.toIso8601String(),
  };
}
