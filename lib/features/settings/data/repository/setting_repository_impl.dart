import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/settings/data/data_source/setting_remote_data_source.dart';
import 'package:fourtyninehub/features/settings/domain/entities/disable_entity.dart';
import 'package:fourtyninehub/features/settings/domain/repository/setting_repository.dart';

class SettingRepositoryImpl extends SettingRepository {
  final SettingRemoteDataSource _settingRemoteDataSource;

  SettingRepositoryImpl(this._settingRemoteDataSource);
  @override
  Future<Either<Failure, bool>> deleteAccount() {
    return _settingRemoteDataSource.deleteAccount();
  }

  @override
  Future<Either<Failure, DisableEntity>> disableAccount() {
    return _settingRemoteDataSource.disableAccount();
  }

  @override
  Future<Either<Failure, DisableEntity>> enableAccount() {
    return _settingRemoteDataSource.enableAccount();
  }
}
