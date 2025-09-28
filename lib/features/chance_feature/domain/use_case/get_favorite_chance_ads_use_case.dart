import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../entity/chance_ad_entity.dart';
import '../repository/chance_repository.dart';

class GetFavoriteChanceAdsUseCase extends UseCase<List<ChanceAdEntity>, NoParams> {
  final ChanceRepository repository;

  GetFavoriteChanceAdsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChanceAdEntity>>> call(NoParams params) async {
    return await repository.getFavoriteChanceAds();
  }
}