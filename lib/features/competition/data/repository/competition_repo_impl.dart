import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/utils/api_service.dart';
import 'package:fourtyninehub/features/competition/data/models/competion_model.dart';
import 'package:fourtyninehub/features/competition/data/repository/competition_repo.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/shared_pref.dart';
import '../models/winners_model.dart';

class CompetitionRepoImpl implements CompetitionRepo {
  final ApiService apiService;

  CompetitionRepoImpl(this.apiService);
  @override
  Future<Either<Failure, CompetitionModel>> fetchCompetition() async {
    try {
      String? accessToken = await TokenManager.getAccessToken();
      String? refreshToken = await TokenManager.getRefreshToken();
      var data = await apiService.get(
          url: 'api/v1/subscriber/competitionsSubscriber', token: accessToken);

      var competition = CompetitionModel.fromJson(data);

      return right(competition);
    } on Exception catch (e) {
      // Handle general exceptions
      final failure = _mapExceptionToFailure(e);
      return left(failure);
    }
  }

  Failure _mapExceptionToFailure(Exception e) {
    // Implement mapping from generic exception to Failure
    // For example, you might inspect the exception to determine the cause
    return ServerFailure(
      message: e.toString(), // Customize this based on the exception details
      statusCode:
          null, // You may need to extract status code from the exception if available
      errors: [e.toString()], // Customize this based on the exception details
    );
  }

  @override
  Future<Either<Failure, WinnersModel>> fetchWinners() async {
    try {
      String? accessToken = await TokenManager.getAccessToken();
      String? refreshToken = await TokenManager.getRefreshToken();
      var data = await apiService.get(
          url: 'api/v1/subscriber/winners', token: accessToken);

      var winner = WinnersModel.fromJson(data);

      return right(winner);
    } on Exception catch (e) {
      // Handle general exceptions
      final failure = _mapExceptionToFailure(e);
      return left(failure);
    }
  }
}
