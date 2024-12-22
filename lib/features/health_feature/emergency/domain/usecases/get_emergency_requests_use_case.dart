import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/entities/emergency_entity.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/repositories/emergency_repo.dart';

class GetEmergencyRequestsUseCase
    extends UseCase<List<EmergencyEntity>, GetEmergencyRequestsParams> {
  final HealthEmergencyRepo _repo;
  GetEmergencyRequestsUseCase(this._repo);

  @override
  Future<Either<Failure, List<EmergencyEntity>>> call(GetEmergencyRequestsParams params) {
    return _repo.getEmergencyRequests(params);
  }
}

class GetEmergencyRequestsParams{
  final String subCategoryId;
  final int page;
  final int limit;

  GetEmergencyRequestsParams({required this.subCategoryId,required this.page,required this.limit});

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
      };
}

