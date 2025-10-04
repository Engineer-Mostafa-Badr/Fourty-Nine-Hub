import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../entity/winner_statistics_entity.dart';
import '../repository/chance_repository.dart';

class GetWinnerStatisticsUseCase extends UseCase<WinnerStatisticsEntity, NoParams> {
  final ChanceRepository repository;

  GetWinnerStatisticsUseCase(this.repository);

  @override
  Future<Either<Failure, WinnerStatisticsEntity>> call(NoParams params) async {
    return await repository.getWinnerStatistics();
  }
}