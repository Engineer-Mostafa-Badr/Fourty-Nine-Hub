import 'package:fourtyninehub/features/social_media/stories/data/data_sources/stories_data_source.dart';
import 'package:fourtyninehub/features/social_media/stories/data/repositories/stories_repository_impl.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/repositories/stories_repository.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/create_story_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/delete_story_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/fetch_stories_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/get_followers_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/get_muted_stories_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/get_story_viewrs_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/make_view_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/mute_stories_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/update_privacy_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:get_it/get_it.dart';

class StoriesServiceLocator {
  static void execute({required GetIt serviceLocator}) {
    serviceLocator.registerLazySingleton<StoriesRemoteDataSource>(
      () => StoriesRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );

    // Register the StoriesRepository
    serviceLocator.registerLazySingleton<StoriesRepository>(
      () => StoriesRepositoryImpl(serviceLocator()),
    );
    // Register the StoryCubit
    serviceLocator.registerFactory<StoryCubit>(
      () => StoryCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator()),
    ); //
    // // use cases
    serviceLocator.registerLazySingleton<MakeViewUseCase>(
      () => MakeViewUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<CreateStoryUseCase>(
      () => CreateStoryUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<MuteStoriesUseCase>(
      () => MuteStoriesUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<GetMutedStoriesUseCase>(
      () => GetMutedStoriesUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<GetStoryViewersUseCase>(
      () => GetStoryViewersUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<GetFollowersUseCase>(
      () => GetFollowersUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<UpdateStoryPrivacyUseCase>(
      () => UpdateStoryPrivacyUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<DeleteStoryUseCase>(
      () => DeleteStoryUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<FetchStoriesUseCase>(
      () => FetchStoriesUseCase(
        serviceLocator(),
      ),
    );
  }
}
