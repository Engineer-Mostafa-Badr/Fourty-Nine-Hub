import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/chance_feature/data/data_source/chance_remote_data_source.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/cahnce_rate_entity.dart';

import 'package:fourtyninehub/features/chance_feature/domain/entity/chance_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/main_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/sub_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/add_chance_data.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_chance_rate_use_case.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_main_category.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_sub_category.dart';

import '../../domain/repository/chance_repository.dart';

class ChanceRepositoryImpl extends ChanceRepository {
  final ChanceRemoteDataSource _chanceRemoteDataSource;

  ChanceRepositoryImpl(this._chanceRemoteDataSource);

  @override
  Future<List<ChanceEntity>> fetchChance() {
    return _chanceRemoteDataSource.fetchChance();
  }

  @override
  Future<Either<Failure, bool>> addChance(AddChanceParams params) {
    return _chanceRemoteDataSource.addChance(params);
  }

  @override
  Future<Either<Failure, ChanceRateEntity>> fetchChanceRate(
      ChanceRateParams params) {
    return _chanceRemoteDataSource.fetchChanceRate(params);
  }

  @override
  Future<Either<Failure, List<MainCategoryDropEntity>>> fetchMainCategory(
      MainCategoryChanceParams params) {
    return _chanceRemoteDataSource.fetchMainCategory(params);
  }

  @override
  Future<Either<Failure, List<SubCategoryDropEntity>>> fetchSubCategory(
      SubCategoryChanceParams params) {
    return _chanceRemoteDataSource.fetchSubCategory(params);
  }
}
