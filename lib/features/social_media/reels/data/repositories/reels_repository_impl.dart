import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/reel_entity.dart';
import '../../domain/repositories/reels_repository.dart';
import '../data_sources/reels_remote_data_source.dart';

class ReelsRepositoryImpl extends ReelsRepository {
  final ReelsRemoteDataSource _reelsRemoteDataSource;

  ReelsRepositoryImpl(this._reelsRemoteDataSource);

  @override
  Future<Either<Failure, List<ReelEntity>>> getExploreReels(int page) {
    return _reelsRemoteDataSource.getExploreReels(page);
  }
}
