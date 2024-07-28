import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/usecases/book_emergency.dart';

abstract class HealthEmergencyRepo {
  Future<Either<Failure, bool>> bookEmergency(BookHealthEmergencyParams params);
}
