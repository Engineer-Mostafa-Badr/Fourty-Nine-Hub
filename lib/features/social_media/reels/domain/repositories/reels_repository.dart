import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/reel_entity.dart';

abstract class ReelsRepository {
  Future<Either<Failure, List<ReelEntity>>> getExploreReels(int page);
}
