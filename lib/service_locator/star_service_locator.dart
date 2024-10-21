import 'package:fourtyninehub/features/star_feature/data/data_source/star_remote_data_source.dart';
import 'package:fourtyninehub/features/star_feature/data/repository/star_repository_impl.dart';
import 'package:fourtyninehub/features/star_feature/domain/repository/star_repository.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/delete_my_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/fetch_all_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/fetch_myl_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/upload_my_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_cubit.dart';
import 'package:get_it/get_it.dart';

class StarServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<StarRemoteDataSource>(
        () => StarRemoteDataSourceImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<StarRepository>(() => StarRepositoryImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<FetchAllStarUseCase>(() => FetchAllStarUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<FetchMylStarUseCase>(
        () => FetchMylStarUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<UploadMyStarUseCase>(
        () => UploadMyStarUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<DeleteMyStarUseCase>(
        () => DeleteMyStarUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<StarCubit>(() => StarCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
  }
}
