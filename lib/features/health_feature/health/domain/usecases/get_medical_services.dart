import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/repositories/health_repo.dart';

class GetMedicalServicesUseCase
    extends UseCase<List<HealthSubcategoryEntity>, String> {
  final HealthRepo _healthRepo;

  GetMedicalServicesUseCase(this._healthRepo);

  @override
  Future<Either<Failure, List<HealthSubcategoryEntity>>> call(String params) {
    return _healthRepo.getMedicalServices(params);
  }
}
