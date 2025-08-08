import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/disable_entity.dart';

abstract class SettingRepository {
  Future<Either<Failure, bool>> deleteAccount();
  Future<Either<Failure, DisableEntity>> disableAccount();
  Future<Either<Failure, DisableEntity>> enableAccount();
}
