import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/emergency/data/datasources/emergency_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/repositories/emergency_repo.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/usecases/book_emergency.dart';

class HealthEmergencyRepoImpl implements HealthEmergencyRepo {
  final HealthEmergencyRemoteDataSource _dataSource;

  HealthEmergencyRepoImpl(this._dataSource);
  @override
  Future<Either<Failure, bool>> bookEmergency(
      BookHealthEmergencyParams params) {
    return _dataSource.bookEmergency(params);
  }
}
