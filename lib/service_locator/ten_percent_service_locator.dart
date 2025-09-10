import 'package:get_it/get_it.dart';
import '../features/ten_percent/data/datasources/ten_percent_remote_data_source.dart';
import '../features/ten_percent/data/repositories/ten_percent_repo_impl.dart';
import '../features/ten_percent/domain/repositories/ten_percent_repo.dart';
import '../features/ten_percent/domain/usecases/send_bill_request_use_case.dart';
import '../features/ten_percent/domain/usecases/get_winners_ten_percent_use_case.dart';
import '../features/ten_percent/presentation/cubit/ten_percent_cubit.dart';
import '../features/ten_percent/presentation/cubit/winners_ten_percent_cubit/winners_ten_percent_cubit.dart';

class TenPercentServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    // Remote Data Source
    serviceLocator.registerLazySingleton<TenPercentRemoteDataSource>(
        () => TenPercentRemoteDataSourceImpl(
              serviceLocator(),
            ));

    // Repository
    serviceLocator.registerLazySingleton<TenPercentRepo>(
        () => TenPercentRepoImpl(
              serviceLocator(),
            ));

    // Use Cases
    serviceLocator.registerLazySingleton<SentBillRequestUseCase>(
        () => SentBillRequestUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetWinnersTenPercentUseCase>(
        () => GetWinnersTenPercentUseCase(
              serviceLocator(),
            ));

    // Cubits
    serviceLocator.registerFactory<TenPercentCubit>(
        () => TenPercentCubit(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<WinnersTenPercentCubit>(
        () => WinnersTenPercentCubit(
              serviceLocator(),
            ));
  }
}