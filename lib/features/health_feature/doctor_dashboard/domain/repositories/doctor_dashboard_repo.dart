import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

abstract class DoctorDashboardRepo {
  Future<Either<Failure, int>> getPracticingRemainingDays(String doctorId);
  Future<Either<Failure, int>> getIDRemainingDays(String doctorId);
  Future<Either<Failure, int>> getSubscriptionRemainingDays(String doctorId);
}
