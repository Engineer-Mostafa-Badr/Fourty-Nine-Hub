import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_all_followers_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_all_following_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/followers_cubit/follower_cubit.dart';
import 'package:get_it/get_it.dart';

class FollowServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {

    serviceLocator
        .registerLazySingleton<GetAllFollowersUseCase>(() => GetAllFollowersUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetAllFollowingUseCase>(
        () => GetAllFollowingUseCase(
              serviceLocator(),
            ));


    serviceLocator.registerFactory<FollowCubit>(() => FollowCubit(
          serviceLocator(),
          serviceLocator(),
        ));
  }
}
