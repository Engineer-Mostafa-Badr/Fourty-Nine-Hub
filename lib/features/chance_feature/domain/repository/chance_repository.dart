import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/chance_entity.dart';

import '../use_case/add_chance_data.dart';

abstract class ChanceRepository{
  Future<List<ChanceEntity>> fetchChance();
  Future<Either<Failure , bool>> addChance(AddChanceParams params ) ;
}