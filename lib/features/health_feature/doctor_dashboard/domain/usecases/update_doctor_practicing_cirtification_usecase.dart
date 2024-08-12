import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_id_usecase.dart';

class UpdateDoctorPracticingCirtificateUsecase
    extends UseCase<bool, DoctorDocsParams> {
  final DoctorDashboardRepo _repo;

  UpdateDoctorPracticingCirtificateUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(DoctorDocsParams params) {
    return _repo.updatePracticingCirtificate(params);
  }
}
