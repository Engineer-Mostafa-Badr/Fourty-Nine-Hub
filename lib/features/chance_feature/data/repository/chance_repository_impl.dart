import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/chance_feature/data/data_source/chance_remote_data_source.dart';

import 'package:fourtyninehub/features/chance_feature/domain/entity/chance_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/add_chance_data.dart';

import '../../domain/repository/chance_repository.dart';

class ChanceRepositoryImpl extends ChanceRepository{
  final ChanceRemoteDataSource _chanceRemoteDataSource;

  ChanceRepositoryImpl(this._chanceRemoteDataSource);
  @override
  Future<List<ChanceEntity>> fetchChance() {
   return _chanceRemoteDataSource.fetchChance();
  }

  @override
  Future<Either<Failure, bool>> addChance(AddChanceParams params) {
    return _chanceRemoteDataSource.addChance(params) ;
  }
}