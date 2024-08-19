import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_statistics_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class GetDoctorStatisticsUsecase
    extends UseCase<DoctorStatisticsEntity, NoParams> {
  final DoctorDashboardRepo _repo;

  GetDoctorStatisticsUsecase(this._repo);

  @override
  Future<Either<Failure, DoctorStatisticsEntity>> call(NoParams params) {
    return _repo.getDoctorStatistics();
  }
}
