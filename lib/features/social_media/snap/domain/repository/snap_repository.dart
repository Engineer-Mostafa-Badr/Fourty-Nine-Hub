import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/snap/domain/entity/filter_entity.dart';

abstract class SnapRepository{
  Future<Either<Failure,List<FilterEntity>>> fetchFilter();
}