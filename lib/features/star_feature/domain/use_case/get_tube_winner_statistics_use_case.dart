import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entity/tube_winner_statistics_entity.dart';
import '../repository/star_repository.dart';

class GetTubeWinnerStatisticsUseCase extends UseCase<TubeWinnerStatisticsEntity, NoParams> {
  final StarRepository repository;

  GetTubeWinnerStatisticsUseCase(this.repository);

  @override
  Future<Either<Failure, TubeWinnerStatisticsEntity>> call(NoParams params) async {
    return await repository.getTubeWinnerStatistics();
  }
}