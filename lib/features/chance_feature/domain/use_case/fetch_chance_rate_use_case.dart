import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/cahnce_rate_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/repository/chance_repository.dart';

class GetChanceRateUseCase
    extends UseCase<ChanceRateEntity, ChanceRateParams> {
  final ChanceRepository _chanceRepository;

  GetChanceRateUseCase(this._chanceRepository);

  @override
  Future<Either<Failure, ChanceRateEntity>> call(
      ChanceRateParams params) async
  {
    return await _chanceRepository.fetchChanceRate(params);
  }
}

class ChanceRateParams {
  final String chanceRateParams;

  ChanceRateParams({required this.chanceRateParams});
}
