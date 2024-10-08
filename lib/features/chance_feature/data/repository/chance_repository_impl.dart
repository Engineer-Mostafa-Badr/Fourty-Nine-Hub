import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/chance_feature/data/data_source/chance_remote_data_source.dart';

import 'package:fourtyninehub/features/chance_feature/domain/entity/chance_entity.dart';

import '../../domain/repository/chance_repository.dart';

class ChanceRepositoryImpl extends ChanceRepository{
  final ChanceRemoteDataSource _chanceRemoteDataSource;

  ChanceRepositoryImpl(this._chanceRemoteDataSource);
  @override
  Future<Either<Failure, List<ChanceEntity>>> fetchChance() {
   return _chanceRemoteDataSource.fetchChance();
  }
}