import '../features/star_feature/data/data_source/star_remote_data_source.dart';
import '../features/star_feature/data/data_source/profile_remote_data_source.dart';
import '../features/star_feature/data/data_source/playlist_remote_data_source.dart';
import '../features/star_feature/data/repository/star_repository_impl.dart';
import '../features/star_feature/data/repository/profile_repository.dart';
import '../features/star_feature/data/repository/playlist_repository_impl.dart';
import '../features/star_feature/domain/repository/star_repository.dart';
import '../features/star_feature/domain/repository/profile_repository.dart';
import '../features/star_feature/domain/repository/playlist_repository.dart';
import '../features/star_feature/domain/use_case/delete_my_star_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_all_star_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_banner_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_myl_star_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_winner_star_use_case.dart';
import '../features/star_feature/domain/use_case/search_profiles_use_case.dart';
import '../features/star_feature/domain/use_case/tube_watch_later_use_cases.dart';
import '../features/star_feature/domain/use_case/upload_my_star_use_case.dart';
import '../features/star_feature/domain/use_case/get_active_categories_use_case.dart';
import '../features/star_feature/domain/use_case/get_tube_winner_statistics_use_case.dart';
import '../features/star_feature/domain/use_case/get_my_profile_use_case.dart';
import '../features/star_feature/domain/use_case/get_profile_by_id_use_case.dart';
import '../features/star_feature/domain/use_case/update_profile_use_case.dart';
import '../features/star_feature/domain/use_case/subscribe_to_channel_use_case.dart';
import '../features/star_feature/domain/use_case/unsubscribe_from_channel_use_case.dart';
import '../features/star_feature/domain/use_case/search_tube_videos_use_case.dart';
import '../features/star_feature/domain/use_case/tube_favorite_use_cases.dart';
import '../features/star_feature/domain/use_case/fetch_all_tube_videos_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_my_tube_videos_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_tube_video_details_by_iduse_case.dart';
import '../features/star_feature/domain/use_case/like_tube_video_use_case.dart';
import '../features/star_feature/domain/use_case/dislike_tube_video_use_case.dart';
import '../features/star_feature/domain/use_case/increment_tube_video_view_use_case.dart';
import '../features/star_feature/domain/use_case/rate_tube_video_use_case.dart';
import '../features/star_feature/domain/use_case/delete_tube_video_use_case.dart';
import '../features/star_feature/domain/use_case/comment_use_cases.dart';
import '../features/star_feature/domain/use_case/playlist_use_cases.dart';
import '../features/star_feature/presentation/controller/star_cubit/star_cubit.dart';
import '../features/star_feature/presentation/controller/comment_cubit/comment_cubit.dart';
import '../features/star_feature/presentation/controller/profile_cubit/profile_cubit.dart';
import '../features/star_feature/presentation/controller/playlist_cubit/playlist_cubit.dart';
import '../features/ten_percent/data/datasources/ten_percent_remote_data_source.dart';
import '../features/ten_percent/data/repositories/ten_percent_repo_impl.dart';
import '../features/ten_percent/domain/repositories/ten_percent_repo.dart';
import '../features/ten_percent/domain/usecases/get_winners_ten_percent_use_case.dart';
import '../features/ten_percent/domain/usecases/send_bill_request_use_case.dart';
import '../features/ten_percent/presentation/cubit/ten_percent_cubit.dart';
import '../features/ten_percent/presentation/cubit/winners_ten_percent_cubit/winners_ten_percent_cubit.dart';
import 'package:get_it/get_it.dart';

class StarServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<StarRemoteDataSource>(
        () => StarRemoteDataSourceImpl(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<PlaylistRemoteDataSource>(
        () => PlaylistRemoteDataSourceImpl(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<TenPercentRemoteDataSource>(
        () => TenPercentRemoteDataSourceImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<StarRepository>(() => StarRepositoryImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<PlaylistRepository>(() => PlaylistRepositoryImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<TenPercentRepo>(() => TenPercentRepoImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<FetchAllStarUseCase>(() => FetchAllStarUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<FetchMylStarUseCase>(() => FetchMylStarUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<UploadMyStarUseCase>(() => UploadMyStarUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<DeleteMyStarUseCase>(() => DeleteMyStarUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<FetchWinnerStarUseCase>(
        () => FetchWinnerStarUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<SentBillRequestUseCase>(
        () => SentBillRequestUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetWinnersTenPercentUseCase>(
        () => GetWinnersTenPercentUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<FetchBannerUseCase>(() => FetchBannerUseCase(
              serviceLocator(),
            ));

    // Register SearchProfilesUseCase
    serviceLocator.registerLazySingleton<SearchProfilesUseCase>(
      () => SearchProfilesUseCase(serviceLocator()),
    );

    // Register GetActiveCategoriesUseCase
    serviceLocator.registerLazySingleton<GetActiveCategoriesUseCase>(
      () => GetActiveCategoriesUseCase(serviceLocator()),
    );

    // Register GetTubeWinnerStatisticsUseCase
    serviceLocator.registerLazySingleton<GetTubeWinnerStatisticsUseCase>(
      () => GetTubeWinnerStatisticsUseCase(serviceLocator()),
    );

    // Register Profile Use Cases
    serviceLocator.registerLazySingleton<GetMyProfileUseCase>(
      () => GetMyProfileUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<GetProfileByIdUseCase>(
      () => GetProfileByIdUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<SubscribeToChannelUseCase>(
      () => SubscribeToChannelUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<UnsubscribeFromChannelUseCase>(
      () => UnsubscribeFromChannelUseCase(serviceLocator()),
    );

    // Register missing use cases for StarCubit
    serviceLocator.registerLazySingleton<SearchTubeVideosUseCase>(
      () => SearchTubeVideosUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<AddVideoToFavoriteUseCase>(
      () => AddVideoToFavoriteUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<RemoveVideoFromFavoriteUseCase>(
      () => RemoveVideoFromFavoriteUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<GetFavoriteVideosUseCase>(
      () => GetFavoriteVideosUseCase(serviceLocator()),
    );

    // Register Watch Later Use Cases
    serviceLocator.registerLazySingleton<AddVideoToWatchLaterUseCase>(
      () => AddVideoToWatchLaterUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<RemoveVideoFromWatchLaterUseCase>(
      () => RemoveVideoFromWatchLaterUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<GetWatchLaterVideosUseCase>(
      () => GetWatchLaterVideosUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<FetchAllTubeVideosUseCase>(
      () => FetchAllTubeVideosUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<FetchMyTubeVideosUseCase>(
      () => FetchMyTubeVideosUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<FetchTubeVideoDetailsByIdUseCase>(
      () => FetchTubeVideoDetailsByIdUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<LikeTubeVideoUseCase>(
      () => LikeTubeVideoUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<DislikeTubeVideoUseCase>(
      () => DislikeTubeVideoUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<IncrementTubeVideoViewUseCase>(
      () => IncrementTubeVideoViewUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<RateTubeVideoUseCase>(
      () => RateTubeVideoUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<DeleteTubeVideoUseCase>(
      () => DeleteTubeVideoUseCase(serviceLocator()),
    );

    // Register Comment Use Cases
    serviceLocator.registerLazySingleton<CreateCommentUseCase>(
      () => CreateCommentUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<GetCommentsUseCase>(
      () => GetCommentsUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<UpdateCommentUseCase>(
      () => UpdateCommentUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<DeleteCommentUseCase>(
      () => DeleteCommentUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<LikeCommentUseCase>(
      () => LikeCommentUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<DislikeCommentUseCase>(
      () => DislikeCommentUseCase(serviceLocator()),
    );

    // Register Playlist Use Cases
    serviceLocator.registerLazySingleton<GetPlaylistsUseCase>(
      () => GetPlaylistsUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<CreatePlaylistUseCase>(
      () => CreatePlaylistUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<GetPlaylistByIdUseCase>(
      () => GetPlaylistByIdUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<GetPlaylistWithVideosUseCase>(
      () => GetPlaylistWithVideosUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<AddVideoToPlaylistUseCase>(
      () => AddVideoToPlaylistUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<RemoveVideoFromPlaylistUseCase>(
      () => RemoveVideoFromPlaylistUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<DeletePlaylistUseCase>(
      () => DeletePlaylistUseCase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<UpdatePlaylistUseCase>(
      () => UpdatePlaylistUseCase(serviceLocator()),
    );

    // Register Cubits
    serviceLocator.registerFactory<CommentCubit>(() => CommentCubit(
          serviceLocator<CreateCommentUseCase>(),
          serviceLocator<GetCommentsUseCase>(),
          serviceLocator<UpdateCommentUseCase>(),
          serviceLocator<DeleteCommentUseCase>(),
          serviceLocator<LikeCommentUseCase>(),
          serviceLocator<DislikeCommentUseCase>(),
        ));

    serviceLocator.registerFactory<ProfileCubit>(() => ProfileCubit(
          serviceLocator<GetMyProfileUseCase>(),
          serviceLocator<GetProfileByIdUseCase>(),
          serviceLocator<UpdateProfileUseCase>(),
          serviceLocator<SubscribeToChannelUseCase>(),
          serviceLocator<UnsubscribeFromChannelUseCase>(),
        ));

    serviceLocator.registerFactory<PlaylistCubit>(() => PlaylistCubit(
          serviceLocator<GetPlaylistsUseCase>(),
          serviceLocator<CreatePlaylistUseCase>(),
          serviceLocator<GetPlaylistByIdUseCase>(),
          serviceLocator<GetPlaylistWithVideosUseCase>(),
          serviceLocator<AddVideoToPlaylistUseCase>(),
          serviceLocator<RemoveVideoFromPlaylistUseCase>(),
          serviceLocator<DeletePlaylistUseCase>(),
          serviceLocator<UpdatePlaylistUseCase>(),
        ));

    serviceLocator.registerFactory<StarCubit>(() => StarCubit(
          serviceLocator<FetchAllStarUseCase>(),
          serviceLocator<FetchMylStarUseCase>(),
          serviceLocator<UploadMyStarUseCase>(),
          serviceLocator<DeleteMyStarUseCase>(),
          serviceLocator<FetchWinnerStarUseCase>(),
          serviceLocator<FetchBannerUseCase>(),
          serviceLocator<SearchProfilesUseCase>(),
          serviceLocator<SearchTubeVideosUseCase>(),
          serviceLocator<AddVideoToFavoriteUseCase>(),
          serviceLocator<RemoveVideoFromFavoriteUseCase>(),
          serviceLocator<GetFavoriteVideosUseCase>(),
          // Watch Later dependencies
          serviceLocator<AddVideoToWatchLaterUseCase>(),
          serviceLocator<RemoveVideoFromWatchLaterUseCase>(),
          serviceLocator<GetWatchLaterVideosUseCase>(),
          // New Tube Video dependencies
          serviceLocator<FetchAllTubeVideosUseCase>(),
          serviceLocator<FetchMyTubeVideosUseCase>(),
          serviceLocator<FetchTubeVideoDetailsByIdUseCase>(),
          serviceLocator<LikeTubeVideoUseCase>(),
          serviceLocator<DislikeTubeVideoUseCase>(),
          serviceLocator<IncrementTubeVideoViewUseCase>(),
          serviceLocator<RateTubeVideoUseCase>(),
          serviceLocator<DeleteTubeVideoUseCase>(),
          serviceLocator<GetTubeWinnerStatisticsUseCase>(),
        ));

    serviceLocator.registerFactory<TenPercentCubit>(() => TenPercentCubit(
          serviceLocator(),
        ));

    serviceLocator
        .registerFactory<WinnersTenPercentCubit>(() => WinnersTenPercentCubit(
              serviceLocator(),
            ));
  }
}
