import 'package:fourtyninehub/features/competition/data/data_source/competition_remote_data_source.dart';
import 'package:fourtyninehub/features/competition/data/repository/competition_repo_impl.dart';
import 'package:fourtyninehub/features/competition/domain/repository/competition_repository.dart';
import 'package:fourtyninehub/features/competition/domain/use_case/fetch_competition_use_case.dart';
import 'package:fourtyninehub/features/competition/domain/use_case/fetch_winner_competition_use_case.dart';
import 'package:fourtyninehub/features/competition/presentation/cubit/competition_cubit/competition_cubit.dart';
import 'package:get_it/get_it.dart';

class CompetitionServiceLocator {
  static void execute({required GetIt serviceLocator}) {
    serviceLocator.registerLazySingleton<CompetitionRemoteDataSource>(
      () => CompetitionRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<CompetitionRepository>(
      () => CompetitionRepositoryImpl(
        serviceLocator(),
      ),
    );

    // use cases
    serviceLocator.registerLazySingleton<FetchCompetitionUseCase>(
      () => FetchCompetitionUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<FetchWinnerCompetitionUseCase>(
      () => FetchWinnerCompetitionUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerFactory<CompetitionCubit>(
      () => CompetitionCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
  }
}
