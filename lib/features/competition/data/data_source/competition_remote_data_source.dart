import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/competition/data/models/competion_model.dart';
import 'package:fourtyninehub/features/competition/data/models/winners_model.dart';
import 'package:fourtyninehub/features/competition/domain/entity/competition_entity.dart';
import 'package:fourtyninehub/features/competition/domain/entity/winner_competition_entity.dart';

abstract class CompetitionRemoteDataSource{
  Future<Either<Failure,List<CompetitionEntity>>> fetchCompetition();
  Future<Either<Failure,List<WinnerCompetitionEntity>>> fetchWinner();
}

class CompetitionRemoteDataSourceImpl extends CompetitionRemoteDataSource{
  final ApiConsumer _apiConsumer;

  CompetitionRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<CompetitionEntity>>> fetchCompetition() async {
    var response = await _apiConsumer.get(EndPoints.competition);

    return response.fold(
          (failure) => Left(failure),
          (response) {
            final list = (response['data'] as List)
                .map((e) => CompetitionModel.fromJson(e))
                .toList();
            return Right(list);
          },
    );
  }

  @override
  Future<Either<Failure, List<WinnerCompetitionEntity>>> fetchWinner() async {
    var response = await _apiConsumer.get(EndPoints.winnerCompetition);

    return response.fold(
          (failure) => Left(failure),
          (response) {
        final list = (response['data'] as List)
            .map((e) => WinnerCompetitionModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }
}