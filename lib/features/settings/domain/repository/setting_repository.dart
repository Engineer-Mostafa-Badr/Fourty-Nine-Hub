import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/settings/domain/entities/disable_entity.dart';

abstract class SettingRepository {
  Future<Either<Failure, bool>> deleteAccount();
  Future<Either<Failure, DisableEntity>> disableAccount();
  Future<Either<Failure, DisableEntity>> enableAccount();
}
