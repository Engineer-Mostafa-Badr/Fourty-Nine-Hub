import 'package:get_it/get_it.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/profile_cubit.dart';

import '../features/star_feature/data/data_source/profile_remote_data_source.dart';
import '../features/star_feature/data/repository/profile_repository.dart';
import '../features/star_feature/domain/repository/profile_repository.dart';
import '../features/star_feature/domain/use_case/get_my_profile_use_case.dart';
import '../features/star_feature/domain/use_case/update_profile_use_case.dart';

class TubeServiceLocator {
  static void execute({required GetIt serviceLocator}) {

    //! profile
    // Data Sources
    serviceLocator.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(serviceLocator()),
    );

    // Repositories
    serviceLocator.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(serviceLocator()),
    );

    // Use Cases
    serviceLocator.registerLazySingleton(() => GetMyProfileUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton(() => UpdateProfileUseCase(serviceLocator()));

    // Cubit
    serviceLocator.registerFactory(() => ProfileCubit(serviceLocator(), serviceLocator()));
  }
}