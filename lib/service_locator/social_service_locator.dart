import 'package:fourtyninehub/features/social_media/chat/chat_room/data/datasources/chat_message_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/repositories/chat_room_repository_implement.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/getChatMessages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/datasources/chats_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/repositories/chats_repository_implement.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatMuteState_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatToArchiveNormal_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getChats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/features/social_media/create_post/data/datasources/create_post_remote_datasource.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/repositories/create_post_repo.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/creat_twitter_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/create_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/get_activities_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/get_feelings_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/datasources/social_posts_remote_datasource.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/repositories/social_posts_repo.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/delete_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_user_posts_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/hide_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/datasources/twitter_remote_datasource.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/repositories/twitter_repo_impl.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/repositories/twitter_repo.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_post_comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_twitter_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/request_document_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/share_twitter_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../features/social_media/create_post/data/repositories/create_post_repo_impl.dart';
import '../features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import '../features/social_media/social_posts/data/repositories/social_posts_repo_impl.dart';
import '../features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/post_react_usecase.dart';

class SocialServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<CreatePostRemoteDataSource>(() =>
        CreatePostRemoteDataSourceImpl(serviceLocator(), serviceLocator()));
    serviceLocator.registerLazySingleton<SocialPostsRemoteDataSource>(
        () => SocialPostsRemoteDataSourceImpl(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<TwitterRemoteDataSource>(
            () => TwitterRemoteDataSourceImpl(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<CreatePostRepo>(
        () => CreatePostRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<SocialPostsRepo>(
        () => SocialPostsRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<TwitterRepo>(
            () => TwitterRepoImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<CreatePostUseCase>(
        () => CreatePostUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetActivitiesUseCase>(
        () => GetActivitiesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetFeelingsUseCase>(
        () => GetFeelingsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<DeletePostUseCase>(
        () => DeletePostUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<HidePostUseCase>(
        () => HidePostUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetFeedUseCase>(() => GetFeedUseCase(
          serviceLocator(),
        ));
    serviceLocator
        .registerLazySingleton<PostReactUseCase>(() => PostReactUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetPostCommentsUseCase>(
        () => GetPostCommentsUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<PostCommentUseCase>(() => PostCommentUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<GetUserPostsUseCase>(() => GetUserPostsUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<GetTwitterFeedUseCase>(() => GetTwitterFeedUseCase(
      serviceLocator(),
    ));

    serviceLocator
        .registerLazySingleton<TwitterPostReactUseCase>(() => TwitterPostReactUseCase(
      serviceLocator(),
    ));

    serviceLocator
        .registerLazySingleton<GetTwitterPostCommentsUseCase>(() => GetTwitterPostCommentsUseCase(
      serviceLocator(),
    ));

    serviceLocator
        .registerLazySingleton<CreateTwitterPostUseCase>(() => CreateTwitterPostUseCase(
      serviceLocator(),
    ));

    serviceLocator
        .registerLazySingleton<TwitterCommentReactUseCase>(() => TwitterCommentReactUseCase(
      serviceLocator(),
    ));

    serviceLocator
        .registerLazySingleton<GetTwitterPostUseCase>(() => GetTwitterPostUseCase(
      serviceLocator(),
    ));

    serviceLocator
        .registerLazySingleton<TwitterSharePostUseCase>(() => TwitterSharePostUseCase(
      serviceLocator(),
    ));

    serviceLocator
        .registerLazySingleton<TwitterPostCommentUseCase>(() => TwitterPostCommentUseCase(
      serviceLocator(),
    ));

    serviceLocator
        .registerLazySingleton<TwitterCommentReplyUseCase>(() => TwitterCommentReplyUseCase(
      serviceLocator(),
    ));

    serviceLocator
        .registerLazySingleton<GetTwitterCommentRepliesUseCase>(() => GetTwitterCommentRepliesUseCase(
      serviceLocator(),
    ));

    serviceLocator
        .registerLazySingleton<TwitterReportUseCase>(() => TwitterReportUseCase(
      serviceLocator(),
    ));

    serviceLocator
        .registerLazySingleton<RequestDocumentUseCase>(() => RequestDocumentUseCase(
      serviceLocator(),
    ));

    serviceLocator.registerFactory<CreatePostCubit>(() => CreatePostCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        )..loadData());

    serviceLocator.registerFactory<InstagramCubit>(() => InstagramCubit());
    serviceLocator.registerFactory<SocialPostsCubit>(() => SocialPostsCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        )..loadData());
    serviceLocator.registerFactory<TwitterCubit>(() => TwitterCubit(
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
    )..loadData());

    // chats

    serviceLocator.registerLazySingleton<ChatsRemoteDataSource>(
        () => ChatsRemoteDataSourceImplementation(serviceLocator()));

    serviceLocator.registerLazySingleton<ChatsRepository>(
        () => ChatsRepositoryImplementation(serviceLocator()));

    serviceLocator.registerFactory<ChatsCubit>(() => ChatsCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));

    serviceLocator.registerFactory<ChatRoomCubit>(() => ChatRoomCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetChatsUseCase>(() => GetChatsUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<ChangeChatMuteStateUseCase>(
        () => ChangeChatMuteStateUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<ChangeChatToArchiveOrNormalUseCase>(
        () => ChangeChatToArchiveOrNormalUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<ChatRoomRepository>(
        () => ChatRoomRepositoryImplementation(serviceLocator()));

    serviceLocator.registerLazySingleton<ChatRemoteDataSource>(
        () => ChatRemoteDataSourceImplementation(serviceLocator()));
    serviceLocator.registerLazySingleton<GetChatMessagesUseCase>(
        () => GetChatMessagesUseCase(
              serviceLocator(),
            ));
  }
}
