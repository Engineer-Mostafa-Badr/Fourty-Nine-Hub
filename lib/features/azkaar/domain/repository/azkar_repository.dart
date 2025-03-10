import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_details_entity.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_entity.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_azkar_use_case.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_details_azkar_use_case.dart';

import '../entity/azkar_search_entity.dart';
import '../use_case/search_azkar_usecase.dart';

abstract class AzkarRepository {
  Future<Either<Failure, List<AzkarEntity>>> fetchAzkar(AzkarParams params);

  Future<Either<Failure, List<AzkarDetailsEntity>>> fetchAzkarDetail(
      AzkarDetailsParams params);

  Future<Either<Failure, List<AzkarSearchEntity>>> searchAzkar(SearchAzkarParams parmas);
}
