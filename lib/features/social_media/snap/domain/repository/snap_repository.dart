import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/filter_entity.dart';

abstract class SnapRepository {
  Future<Either<Failure, List<FilterEntity>>> fetchFilter();
}
