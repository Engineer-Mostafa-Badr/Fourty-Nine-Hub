import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/chance_entity.dart';

abstract class ChanceRepository{
  Future<Either<Failure,List<ChanceEntity>>> fetchChance();
}