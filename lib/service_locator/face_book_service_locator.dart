import 'package:fourtyninehub/features/social_media/reels/domain/use_case/get_global_reels_use_case.dart';

import '../features/social_media/create_post/data/datasources/create_post_remote_datasource.dart';
import '../features/social_media/create_post/data/repositories/create_post_repo_impl.dart';
import '../features/social_media/create_post/domain/repositories/create_post_repo.dart';
import '../features/social_media/create_post/domain/usecases/create_post_usecase.dart';
import '../features/social_media/create_post/domain/usecases/friends-followers_usecase.dart';
import '../features/social_media/create_post/domain/usecases/get_activities_usecase.dart';
import '../features/social_media/create_post/domain/usecases/get_feelings_usecase.dart';
import '../features/social_media/create_post/domain/usecases/get_live_event_categories_usecase.dart';
import '../features/social_media/create_post/domain/usecases/get_live_event_sub_categories_usecase.dart';
import '../features/social_media/create_post/domain/usecases/get_places_usecase.dart';
import '../features/social_media/create_post/domain/usecases/get_sub_activities_usecase.dart';
import '../features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import '../features/social_media/edit_profile/data/datasources/edit_profile_remote_datasource.dart';
import '../features/social_media/edit_profile/data/repositories/edit_profile_repo_impl.dart';
import '../features/social_media/edit_profile/domain/repositories/edit_profile_repo.dart';
import '../features/social_media/edit_profile/domain/usecases/edit_profile_usecase.dart';
import '../features/social_media/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import '../features/social_media/instagram/domain/usecases/get_saved_reels_usecase.dart';
import '../features/social_media/social_posts/data/datasources/social_posts_remote_datasource.dart';
import '../features/social_media/social_posts/data/repositories/social_posts_repo_impl.dart';
import '../features/social_media/social_posts/domain/repositories/social_posts_repo.dart';
import '../features/social_media/social_posts/domain/usecases/accept_reject_friend_request_use_case.dart';
import '../features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/block_user_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/comment_react_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/delete_comment_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/delete_friend_use_case.dart';
import '../features/social_media/social_posts/domain/usecases/delete_post_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/edit_comment_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/face_advertisement_use_case.dart';
import '../features/social_media/social_posts/domain/usecases/face_tweet_use_case.dart';
import '../features/social_media/social_posts/domain/usecases/follow_user_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/friend_request_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/get_feed_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/get_global_feed_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/get_post_comment_replies_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/get_post_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/get_user_posts_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/hide_post_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/remove_friend_request_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/remove_suggest_user_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/search_users_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/send_greet_message_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/share_post_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/suggest_friends_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/un_follow_user_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/user_profile_usecase.dart';
import '../features/social_media/social_posts/domain/usecases/view_profile_usecase.dart';
import '../features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/social_media/edit_profile/domain/usecases/get_governorates.dart';

class FaceBookServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<CreatePostRemoteDataSource>(() =>
        CreatePostRemoteDataSourceImpl(serviceLocator(), serviceLocator()));
    serviceLocator.registerLazySingleton<SocialPostsRemoteDataSource>(
        () => SocialPostsRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<EditProfileRemoteDataSource>(() =>
        EditProfileRemoteDataSourceImpl(serviceLocator(), serviceLocator()));

    serviceLocator.registerLazySingleton<CreatePostRepo>(
        () => CreatePostRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<SocialPostsRepo>(
        () => SocialPostsRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<EditProfileRepo>(
        () => EditProfileRepoImpl(serviceLocator()));


    // serviceLocator.registerLazySingleton<CreateDoctorRepo>(
    //     () => CreateDoctorRepoImpl(serviceLocator()));

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

    serviceLocator.registerLazySingleton<SuggestedFriendsUseCase>(
        () => SuggestedFriendsUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<FriedRequestUseCase>(() => FriedRequestUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<FollowUserUseCase>(() => FollowUserUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<RemoveSuggestUserUseCase>(
        () => RemoveSuggestUserUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<SendGreetMessageUseCase>(
        () => SendGreetMessageUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<SharePostUseCase>(() => SharePostUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<CommentReactUseCase>(() => CommentReactUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetPostCommentRepliesUseCase>(
        () => GetPostCommentRepliesUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<ReplyOnCommentUseCase>(
        () => ReplyOnCommentUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<FaceTweetUseCase>(() => FaceTweetUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<FaceAdvertisementUseCase>(
        () => FaceAdvertisementUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<FriendsFollowersUseCase>(
        () => FriendsFollowersUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetPostUseCase>(() => GetPostUseCase(
          serviceLocator(),
        ));

    serviceLocator
        .registerLazySingleton<SearchUsersUsecase>(() => SearchUsersUsecase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<DeleteCommentUseCase>(() => DeleteCommentUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<UserProfileUseCase>(() => UserProfileUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<ViewProfileUseCase>(() => ViewProfileUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<UnFollowUserUseCase>(() => UnFollowUserUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<RemoveFriedRequestUseCase>(
        () => RemoveFriedRequestUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<BlocUserUseCase>(() => BlocUserUseCase(
          serviceLocator(),
        ));

    serviceLocator
        .registerLazySingleton<EditCommentUseCase>(() => EditCommentUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<GetGlobalFeedUseCase>(() => GetGlobalFeedUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<GetPlacesUseCase>(() => GetPlacesUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<EditProfileUseCase>(() => EditProfileUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<GetSavedReelsUseCase>(() => GetSavedReelsUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<AcceptRejectFriendRequestUseCase>(
        () => AcceptRejectFriendRequestUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetSubActivitiesUseCase>(
        () => GetSubActivitiesUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<DeleteFriendUseCase>(() => DeleteFriendUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<GetLifeEventCategoriesUseCase>(() => GetLifeEventCategoriesUseCase(
              serviceLocator(),
            ));


 serviceLocator
        .registerLazySingleton<GetLifeEventSubCategoriesUseCase>(() => GetLifeEventSubCategoriesUseCase(
              serviceLocator(),
            ));
 serviceLocator
        .registerLazySingleton<GetProfileGovernoratesUseCase>(() => GetProfileGovernoratesUseCase(
              serviceLocator(),
            ));
 serviceLocator
        .registerLazySingleton<GetGlobalReelsUseCase>(() => GetGlobalReelsUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<CreatePostCubit>(() => CreatePostCubit(
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

    serviceLocator.registerFactory<EditProfileCubit>(() => EditProfileCubit(
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
