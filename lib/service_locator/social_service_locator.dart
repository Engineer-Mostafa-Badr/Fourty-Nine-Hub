import 'package:fourtyninehub/features/social_media/chat/chat_room/data/datasources/chat_message_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/repositories/chat_room_repository_implement.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/deleteMessage_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/getChatMessages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/datasources/chats_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/repositories/chats_repository_implement.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatMuteState_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatToArchiveNormal_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getChats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getGroupsChats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getSeenHistoryUseCase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/lock_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/unlock_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/features/social_media/create_post/data/datasources/create_post_remote_datasource.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/repositories/create_post_repo.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/creat_twitter_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/create_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/friends-followers_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/get_activities_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/get_feelings_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/get_places_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/data/datasources/edit_profile_remote_datasource.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/data/repositories/edit_profile_repo_impl.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/domain/repositories/edit_profile_repo.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/domain/usecases/edit_profile_usecase.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/datasources/instagram_remote_datasource.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/repositories/instagram_repo_impl.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/repositories/social_posts_repo.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/datasources/social_posts_remote_datasource.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/repositories/social_posts_repo.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/block_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/delete_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/delete_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/edit_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/face_advertisement_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/face_tweet_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/follow_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/friend_request_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comment_replies_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_user_posts_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/hide_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/remove_friend_request_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/remove_suggest_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/send_greet_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/share_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/suggest_friends_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/un_follow_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/user_profile_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/datasources/twitter_remote_datasource.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/repositories/twitter_repo_impl.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/repositories/twitter_repo.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/delete_twitter_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/delete_twitter_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/edit_twitter_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_post_comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_twitter_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_user_posts_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/hide_twitter_post_usecase.dart';
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
    serviceLocator.registerLazySingleton<CreatePostRemoteDataSource>(
        () => CreatePostRemoteDataSourceImpl(serviceLocator(), serviceLocator()));
    serviceLocator.registerLazySingleton<EditProfileRemoteDataSource>(
        () => EditProfileRemoteDataSourceImpl(serviceLocator(), serviceLocator()));
    serviceLocator.registerLazySingleton<InstagramRemoteDataSource>(() => InstagramRemoteDataSourceImpl(
          serviceLocator(),
        ));
    serviceLocator.registerLazySingleton<SocialPostsRemoteDataSource>(() => SocialPostsRemoteDataSourceImpl(
          serviceLocator(),
        ));
    serviceLocator.registerLazySingleton<TwitterRemoteDataSource>(() => TwitterRemoteDataSourceImpl(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<CreatePostRepo>(() => CreatePostRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<SocialPostsRepo>(() => SocialPostsRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<TwitterRepo>(() => TwitterRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<InstagramRepo>(() => InstagramRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<EditProfileRepo>(() => EditProfileRepoImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<CreatePostUseCase>(() => CreatePostUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetActivitiesUseCase>(() => GetActivitiesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetFeelingsUseCase>(() => GetFeelingsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<DeletePostUseCase>(() => DeletePostUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<HidePostUseCase>(() => HidePostUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetFeedUseCase>(() => GetFeedUseCase(
          serviceLocator(),
        ));
    serviceLocator.registerLazySingleton<PostReactUseCase>(() => PostReactUseCase(
          serviceLocator(),
        ));
    serviceLocator.registerLazySingleton<GetPostCommentsUseCase>(() => GetPostCommentsUseCase(
          serviceLocator(),
        ));
    serviceLocator.registerLazySingleton<PostCommentUseCase>(() => PostCommentUseCase(
          serviceLocator(),
        ));
    serviceLocator.registerLazySingleton<GetUserPostsUseCase>(() => GetUserPostsUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetTwitterFeedUseCase>(() => GetTwitterFeedUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<TwitterPostReactUseCase>(() => TwitterPostReactUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetTwitterPostCommentsUseCase>(() => GetTwitterPostCommentsUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<CreateTwitterPostUseCase>(() => CreateTwitterPostUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<TwitterCommentReactUseCase>(() => TwitterCommentReactUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetTwitterPostUseCase>(() => GetTwitterPostUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<TwitterSharePostUseCase>(() => TwitterSharePostUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<TwitterPostCommentUseCase>(() => TwitterPostCommentUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<TwitterCommentReplyUseCase>(() => TwitterCommentReplyUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetTwitterCommentRepliesUseCase>(() => GetTwitterCommentRepliesUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<TwitterReportUseCase>(() => TwitterReportUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<RequestDocumentUseCase>(() => RequestDocumentUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetUserTweetsUseCase>(() => GetUserTweetsUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<SuggestedFriendsUseCase>(() => SuggestedFriendsUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<FriedRequestUseCase>(() => FriedRequestUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<FollowUserUseCase>(() => FollowUserUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<RemoveSuggestUserUseCase>(() => RemoveSuggestUserUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<SendGreetMessageUseCase>(() => SendGreetMessageUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<SharePostUseCase>(() => SharePostUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<CommentReactUseCase>(() => CommentReactUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetPostCommentRepliesUseCase>(() => GetPostCommentRepliesUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<ReplyOnCommentUseCase>(() => ReplyOnCommentUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<FaceTweetUseCase>(() => FaceTweetUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<FaceAdvertisementUseCase>(() => FaceAdvertisementUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<FriendsFollowersUseCase>(() => FriendsFollowersUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetInstagramFeedUseCase>(() => GetInstagramFeedUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<HideTwitterPostUseCase>(() => HideTwitterPostUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<DeleteTwitterPostUseCase>(() => DeleteTwitterPostUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetInstagramReelsUseCase>(() => GetInstagramReelsUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetPostUseCase>(() => GetPostUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<DeleteCommentUseCase>(() => DeleteCommentUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<UserProfileUseCase>(() => UserProfileUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<UnFollowUserUseCase>(() => UnFollowUserUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<RemoveFriedRequestUseCase>(() => RemoveFriedRequestUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<BlocUserUseCase>(() => BlocUserUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetInstagramUserReelsUseCase>(() => GetInstagramUserReelsUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<EditCommentUseCase>(() => EditCommentUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetPlacesUseCase>(() => GetPlacesUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<EditTwitterCommentUseCase>(() => EditTwitterCommentUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<EditProfileUseCase>(() => EditProfileUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<DeleteTwitterCommentUseCase>(() => DeleteTwitterCommentUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<DeleteTwitterCommentUseCase>(() => DeleteTwitterCommentUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerFactory<CreatePostCubit>(() => CreatePostCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));

    serviceLocator.registerFactory<EditProfileCubit>(() => EditProfileCubit(
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
        ));
    serviceLocator.registerFactory<SocialPostsCubit>(() => SocialPostsCubit(
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
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
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
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));

    // chats

    serviceLocator
        .registerLazySingleton<ChatsRemoteDataSource>(() => ChatsRemoteDataSourceImplementation(serviceLocator()));

    serviceLocator.registerLazySingleton<ChatsRepository>(() => ChatsRepositoryImplementation(serviceLocator()));

    serviceLocator.registerFactory<ChatsCubit>(() => ChatsCubit(
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

    serviceLocator.registerFactory<ChatRoomCubit>(() => ChatRoomCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetChatsUseCase>(() => GetChatsUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GroupsChatsUseCase>(() => GroupsChatsUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<GetSeenHistoryUseCase>(() => GetSeenHistoryUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<ChangeChatMuteStateUseCase>(() => ChangeChatMuteStateUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<ChangeChatToArchiveOrNormalUseCase>(() => ChangeChatToArchiveOrNormalUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<UnLockChatUseCase>(() => UnLockChatUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<LockChatUseCase>(() => LockChatUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<ChatRoomRepository>(() => ChatRoomRepositoryImplementation(serviceLocator()));

    serviceLocator
        .registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImplementation(serviceLocator()));
    serviceLocator.registerLazySingleton<GetChatMessagesUseCase>(() => GetChatMessagesUseCase(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<DeleteChatMessageUseCase>(() => DeleteChatMessageUseCase(
          serviceLocator(),
        ));
  }
}
