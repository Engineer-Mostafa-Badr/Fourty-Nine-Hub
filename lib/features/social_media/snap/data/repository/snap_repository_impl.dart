import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/snap/data/data_source/snap_remote_data_source.dart';
import 'package:fourtyninehub/features/social_media/snap/domain/entity/filter_entity.dart';
import 'package:fourtyninehub/features/social_media/snap/domain/repository/snap_repository.dart';

class SnapRepositoryImpl extends SnapRepository {
  final SnapRemoteDataSource _remoteDataSource;

  SnapRepositoryImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<FilterEntity>>> fetchFilter() {
    return _remoteDataSource.fetchFilter();
  }
}
