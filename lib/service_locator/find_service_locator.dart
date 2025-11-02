import 'package:get_it/get_it.dart';

import '../features/social_media/find/data/data_sources/find_data_source.dart';
import '../features/social_media/find/data/repositories/find_repository_impl.dart';
import '../features/social_media/find/domain/repositories/find_repository.dart';
import '../features/social_media/find/domain/usecase/add_dis_like_tinder_use_case.dart';
import '../features/social_media/find/domain/usecase/add_like_tinder_use_case.dart';
import '../features/social_media/find/domain/usecase/add_love_tinder_use_case.dart';
import '../features/social_media/find/domain/usecase/get_find_use_case.dart';
import '../features/social_media/find/presentation/cubit/find_cubit.dart';

class FindServiceLocator {
  static void execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<FindRemoteDataSource>(
        () => FindRemoteDataSourceImpl(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<FindRepository>(
        () => FindRepositoryImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<AddLikeFindUseCase>(
        () => AddLikeFindUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<AddDisLikeFindUseCase>(
        () => AddDisLikeFindUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<AddLoveFindUseCase>(
        () => AddLoveFindUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetFindUseCase>(
        () => GetFindUseCase(serviceLocator()));

    serviceLocator.registerFactory<FindCubit>(() => FindCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
  }
}
