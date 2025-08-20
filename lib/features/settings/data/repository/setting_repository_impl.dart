import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../data_source/setting_remote_data_source.dart';
import '../../domain/entities/disable_entity.dart';
import '../../domain/repository/setting_repository.dart';

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
