import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/share_app/data/data_source/share_app_remote_data_source.dart';
import 'package:fourtyninehub/features/account_taps/share_app/domain/entity/share_app_entity.dart';
import 'package:fourtyninehub/features/account_taps/share_app/domain/repository/share_app_repository.dart';

class ShareAppRepositoryImpl extends ShareAppRepository{
  final ShareAppRemoteDataSource _remoteDataSource;

  ShareAppRepositoryImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, ShareAppEntity>> shareApp() {
    return _remoteDataSource.shareApp();
  }
}