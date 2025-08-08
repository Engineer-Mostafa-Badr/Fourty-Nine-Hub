import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../data_source/snap_remote_data_source.dart';
import '../../domain/entity/filter_entity.dart';
import '../../domain/repository/snap_repository.dart';

class SnapRepositoryImpl extends SnapRepository {
  final SnapRemoteDataSource _remoteDataSource;

  SnapRepositoryImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<FilterEntity>>> fetchFilter() {
    return _remoteDataSource.fetchFilter();
  }
}
