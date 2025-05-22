import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ten_percent/domain/entities/winners_ten_percent_entity.dart';
import 'package:fourtyninehub/features/ten_percent/domain/repositories/ten_percent_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetWinnersTenPercentUseCase
    extends UseCase<WinnersTenPercentEntity, GetWinnersTenPercentParams> {
  final TenPercentRepo _repo;
  GetWinnersTenPercentUseCase(this._repo);

  @override
  Future<Either<Failure, WinnersTenPercentEntity>> call(
      GetWinnersTenPercentParams params) {
    return _repo.getWinnersTenPercent(params: params);
  }
}

class GetWinnersTenPercentParams {
  final int page;
  final int limit;
  GetWinnersTenPercentParams({
    required this.page,
    required this.limit,
  });
}
