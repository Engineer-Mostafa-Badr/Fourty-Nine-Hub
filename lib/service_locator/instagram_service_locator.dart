import 'package:fourtyninehub/features/social_media/instagram/data/datasources/instagram_remote_datasource.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/repositories/instagram_repo_impl.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/repositories/social_posts_repo.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_global_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:get_it/get_it.dart';

class InstagramServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<InstagramRemoteDataSource>(
        () => InstagramRemoteDataSourceImpl(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<InstagramRepo>(
        () => InstagramRepoImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<GetInstagramReelsUseCase>(
        () => GetInstagramReelsUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetInstagramUserReelsUseCase>(
        () => GetInstagramUserReelsUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetInstagramFeedUseCase>(
        () => GetInstagramFeedUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetInstagramGlobalFeedUseCase>(
        () => GetInstagramGlobalFeedUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<InstagramCubit>(() => InstagramCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
  }
}
