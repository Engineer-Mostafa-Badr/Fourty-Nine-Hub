import '../features/star_feature/data/data_source/star_remote_data_source.dart';
import '../features/star_feature/data/repository/star_repository_impl.dart';
import '../features/star_feature/domain/repository/star_repository.dart';
import '../features/star_feature/domain/use_case/delete_my_star_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_all_star_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_banner_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_myl_star_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_winner_star_use_case.dart';
import '../features/star_feature/domain/use_case/upload_my_star_use_case.dart';
import '../features/star_feature/presentation/controller/cubit/star_cubit.dart';
import '../features/ten_percent/data/datasources/ten_percent_remote_data_source.dart';
import '../features/ten_percent/data/repositories/ten_percent_repo_impl.dart';
import '../features/ten_percent/domain/repositories/ten_percent_repo.dart';
import '../features/ten_percent/domain/usecases/get_winners_ten_percent_use_case.dart';
import '../features/ten_percent/domain/usecases/send_bill_request_use_case.dart';
import '../features/ten_percent/presentation/cubit/ten_percent_cubit.dart';
import '../features/ten_percent/presentation/cubit/winners_ten_percent_cubit/winners_ten_percent_cubit.dart';
import 'package:get_it/get_it.dart';

class StarServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<StarRemoteDataSource>(
        () => StarRemoteDataSourceImpl(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<TenPercentRemoteDataSource>(
        () => TenPercentRemoteDataSourceImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<StarRepository>(() => StarRepositoryImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<TenPercentRepo>(() => TenPercentRepoImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<FetchAllStarUseCase>(() => FetchAllStarUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<FetchMylStarUseCase>(() => FetchMylStarUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<UploadMyStarUseCase>(() => UploadMyStarUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<DeleteMyStarUseCase>(() => DeleteMyStarUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<FetchWinnerStarUseCase>(
        () => FetchWinnerStarUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<SentBillRequestUseCase>(
        () => SentBillRequestUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetWinnersTenPercentUseCase>(
        () => GetWinnersTenPercentUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<FetchBannerUseCase>(() => FetchBannerUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<StarCubit>(() => StarCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));

    serviceLocator.registerFactory<TenPercentCubit>(() => TenPercentCubit(
          serviceLocator(),
        ));

    serviceLocator
        .registerFactory<WinnersTenPercentCubit>(() => WinnersTenPercentCubit(
              serviceLocator(),
            ));
  }
}
