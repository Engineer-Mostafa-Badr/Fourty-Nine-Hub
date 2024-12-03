import 'package:fourtyninehub/features/account_taps/share_app/data/data_source/share_app_remote_data_source.dart';
import 'package:fourtyninehub/features/account_taps/share_app/data/repository/share_app_repository_impl.dart';
import 'package:fourtyninehub/features/account_taps/share_app/domain/repository/share_app_repository.dart';
import 'package:fourtyninehub/features/account_taps/share_app/domain/use_case/share_app_use_case.dart';
import 'package:fourtyninehub/features/account_taps/share_app/presentation/cubit/share_app_cubit.dart';
import 'package:get_it/get_it.dart';

class ShareAppServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator
        .registerLazySingleton<ShareAppRemoteDataSource>(() => ShareAppRemoteDataSourceImpl(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<ShareAppRepository>(
        () => ShareAppRepositoryImpl(serviceLocator()));

    serviceLocator
        .registerLazySingleton<ShareAppUseCase>(() => ShareAppUseCase(
              serviceLocator(),
            ));


  }
}
