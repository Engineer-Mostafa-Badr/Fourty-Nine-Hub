import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/chance_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/main_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/sub_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_chance_rate_use_case.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_main_category.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_sub_category.dart';

import '../use_case/add_chance_data.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/cahnce_rate_entity.dart';

abstract class ChanceRepository {
  Future<List<ChanceEntity>> fetchChance();
  Future<Either<Failure, bool>> addChance(AddChanceParams params);
  Future<Either<Failure, ChanceRateEntity>> fetchChanceRate(
      ChanceRateParams params);
  Future<Either<Failure, List<MainCategoryDropEntity>>> fetchMainCategory(
      MainCategoryChanceParams params);
  Future<Either<Failure, List<SubCategoryDropEntity>>> fetchSubCategory(
      SubCategoryChanceParams params);
}
