import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/entities/emergency_entity.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/usecases/book_emergency.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/usecases/get_emergency_requests_use_case.dart';

abstract class HealthEmergencyRepo {
  Future<Either<Failure, bool>> bookEmergency(BookHealthEmergencyParams params);
  Future<Either<Failure, List<EmergencyEntity>>> getEmergencyRequests(GetEmergencyRequestsParams params);
}
