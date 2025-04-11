import 'package:fourtyninehub/features/social_media/instagram/data/datasources/instagram_data_source.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/datasources/instagram_remote_datasource.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/repositories/instagram_repo_impl.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/repositories/instagram_repository.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/repositories/social_posts_repo.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/add_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/delete_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_global_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_user_media_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_posts_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_tag_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/comment_instagram_cubit/comments_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/posts_instagram_cubit/posts_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/profile_instagram_cubit/profile_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/reel_instagram_cubit/reel_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/tag_users_cubit/tag_users_cubit.dart';
import 'package:get_it/get_it.dart';

class InstagramServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<InstagramRemoteDataSource>(
        () => InstagramRemoteDataSourceImpl(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton(
        () => InstagramDataSource(api: serviceLocator()));
    serviceLocator.registerLazySingleton(
        () => InstagramRepository(dataSource: serviceLocator()));
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

    serviceLocator.registerLazySingleton<GetInstagramUserMediaUseCase>(
        () => GetInstagramUserMediaUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetPostsUseCase>(() => GetPostsUseCase(
          serviceLocator(),
        ));

    serviceLocator
        .registerLazySingleton<GetUserTagUseCase>(() => GetUserTagUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<GetCommentUseCase>(() => GetCommentUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<AddCommentUseCase>(() => AddCommentUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<DeleteCommentUseCase>(() => DeleteCommentUseCase(
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
          serviceLocator(),
        ));

    serviceLocator.registerFactory<CreatePostInstagramCubit>(
      () => CreatePostInstagramCubit(),
    );

    serviceLocator.registerFactory<PostsInstagramCubit>(
      () => PostsInstagramCubit(
        serviceLocator<GetPostsUseCase>(),
      ),
    );

    serviceLocator.registerLazySingleton<TagUsersCubit>(
      () => TagUsersCubit(serviceLocator<GetUserTagUseCase>()),
    );

    serviceLocator.registerLazySingleton<ProfileInstagramCubit>(
      () => ProfileInstagramCubit(),
    );
    serviceLocator.registerLazySingleton<ReelInstagramCubit>(
      () => ReelInstagramCubit(
        serviceLocator<GetInstagramReelsUseCase>(),
      ),
    );
    serviceLocator.registerLazySingleton<CommentsInstagramCubit>(
      () => CommentsInstagramCubit(
        serviceLocator<GetCommentUseCase>(),
        serviceLocator<AddCommentUseCase>(),
        serviceLocator<DeleteCommentUseCase>(),
      ),
    );
  }
}
