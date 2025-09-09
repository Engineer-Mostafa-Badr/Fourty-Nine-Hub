import 'package:get_it/get_it.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/profile_cubit/profile_cubit.dart';

import '../features/star_feature/data/data_source/playlist_remote_data_source.dart';
import '../features/star_feature/data/data_source/profile_remote_data_source.dart';
import '../features/star_feature/data/repository/playlist_repository_impl.dart';
import '../features/star_feature/data/repository/profile_repository.dart';
import '../features/star_feature/domain/repository/playlist_repository.dart';
import '../features/star_feature/domain/repository/profile_repository.dart';
import '../features/star_feature/domain/use_case/comment_use_cases.dart';
import '../features/star_feature/domain/use_case/delete_tube_video_use_case.dart';
import '../features/star_feature/domain/use_case/get_my_profile_use_case.dart';
import '../features/star_feature/domain/use_case/get_profile_by_id_use_case.dart';
import '../features/star_feature/domain/use_case/playlist_use_cases.dart';
import '../features/star_feature/domain/use_case/search_tube_videos_use_case.dart';
import '../features/star_feature/domain/use_case/tube_favorite_use_cases.dart';
import '../features/star_feature/domain/use_case/update_profile_use_case.dart';

// New imports for Tube Video functionality
import '../features/star_feature/data/data_source/star_remote_data_source.dart';
import '../features/star_feature/data/repository/star_repository_impl.dart';
import '../features/star_feature/domain/repository/star_repository.dart';
import '../features/star_feature/domain/use_case/fetch_all_star_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_myl_star_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_winner_star_use_case.dart';
import '../features/star_feature/domain/use_case/upload_my_star_use_case.dart';
import '../features/star_feature/domain/use_case/delete_my_star_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_banner_use_case.dart';
import '../features/star_feature/domain/use_case/search_profiles_use_case.dart';
// New Tube Video use cases
import '../features/star_feature/domain/use_case/fetch_all_tube_videos_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_my_tube_videos_use_case.dart';
import '../features/star_feature/domain/use_case/fetch_tube_video_details_by_iduse_case.dart';
import '../features/star_feature/domain/use_case/like_tube_video_use_case.dart';
import '../features/star_feature/domain/use_case/dislike_tube_video_use_case.dart';
import '../features/star_feature/domain/use_case/increment_tube_video_view_use_case.dart';
// NEW: Comment use cases imports
import '../features/star_feature/presentation/controller/comment_cubit/comment_cubit.dart';
import '../features/star_feature/presentation/controller/playlist_cubit/playlist_cubit.dart';
import '../features/star_feature/presentation/controller/star_cubit/star_cubit.dart';

class TubeServiceLocator {
  static void execute({required GetIt serviceLocator}) {
    //! Star/Tube Video Data Layer
    // Data Sources - تأكد من عدم تسجيلها مرة أخرى إذا كانت موجودة
    if (!serviceLocator.isRegistered<StarRemoteDataSource>()) {
      serviceLocator.registerLazySingleton<StarRemoteDataSource>(
        () => StarRemoteDataSourceImpl(serviceLocator()),
      );
    }

    // Repositories
    if (!serviceLocator.isRegistered<StarRepository>()) {
      serviceLocator.registerLazySingleton<StarRepository>(
        () => StarRepositoryImpl(serviceLocator()),
      );
    }

    //! Star/Tube Video Use Cases
    // Original Star use cases
    if (!serviceLocator.isRegistered<FetchAllStarUseCase>()) {
      serviceLocator.registerLazySingleton<FetchAllStarUseCase>(
        () => FetchAllStarUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<SearchTubeVideosUseCase>()) {
      serviceLocator.registerLazySingleton<SearchTubeVideosUseCase>(
        () => SearchTubeVideosUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<AddVideoToFavoriteUseCase>()) {
      serviceLocator.registerLazySingleton<AddVideoToFavoriteUseCase>(
        () => AddVideoToFavoriteUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<RemoveVideoFromFavoriteUseCase>()) {
      serviceLocator.registerLazySingleton<RemoveVideoFromFavoriteUseCase>(
        () => RemoveVideoFromFavoriteUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<GetFavoriteVideosUseCase>()) {
      serviceLocator.registerLazySingleton<GetFavoriteVideosUseCase>(
        () => GetFavoriteVideosUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<FetchMylStarUseCase>()) {
      serviceLocator.registerLazySingleton<FetchMylStarUseCase>(
        () => FetchMylStarUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<FetchWinnerStarUseCase>()) {
      serviceLocator.registerLazySingleton<FetchWinnerStarUseCase>(
        () => FetchWinnerStarUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<UploadMyStarUseCase>()) {
      serviceLocator.registerLazySingleton<UploadMyStarUseCase>(
        () => UploadMyStarUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<DeleteMyStarUseCase>()) {
      serviceLocator.registerLazySingleton<DeleteMyStarUseCase>(
        () => DeleteMyStarUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<FetchBannerUseCase>()) {
      serviceLocator.registerLazySingleton<FetchBannerUseCase>(
        () => FetchBannerUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<SearchProfilesUseCase>()) {
      serviceLocator.registerLazySingleton<SearchProfilesUseCase>(
        () => SearchProfilesUseCase(serviceLocator()),
      );
    }

    // New Tube Video use cases
    if (!serviceLocator.isRegistered<FetchAllTubeVideosUseCase>()) {
      serviceLocator.registerLazySingleton<FetchAllTubeVideosUseCase>(
        () => FetchAllTubeVideosUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<FetchMyTubeVideosUseCase>()) {
      serviceLocator.registerLazySingleton<FetchMyTubeVideosUseCase>(
        () => FetchMyTubeVideosUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<FetchTubeVideoDetailsByIdUseCase>()) {
      serviceLocator.registerLazySingleton<FetchTubeVideoDetailsByIdUseCase>(
        () => FetchTubeVideoDetailsByIdUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<LikeTubeVideoUseCase>()) {
      serviceLocator.registerLazySingleton<LikeTubeVideoUseCase>(
        () => LikeTubeVideoUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<DislikeTubeVideoUseCase>()) {
      serviceLocator.registerLazySingleton<DislikeTubeVideoUseCase>(
        () => DislikeTubeVideoUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<IncrementTubeVideoViewUseCase>()) {
      serviceLocator.registerLazySingleton<IncrementTubeVideoViewUseCase>(
        () => IncrementTubeVideoViewUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<DeleteTubeVideoUseCase>()) {
      serviceLocator.registerLazySingleton<DeleteTubeVideoUseCase>(
        () => DeleteTubeVideoUseCase(serviceLocator()),
      );
    }

    //! NEW: Comment Use Cases Registration
    if (!serviceLocator.isRegistered<CreateCommentUseCase>()) {
      serviceLocator.registerLazySingleton<CreateCommentUseCase>(
        () => CreateCommentUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<GetCommentsUseCase>()) {
      serviceLocator.registerLazySingleton<GetCommentsUseCase>(
        () => GetCommentsUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<UpdateCommentUseCase>()) {
      serviceLocator.registerLazySingleton<UpdateCommentUseCase>(
        () => UpdateCommentUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<DeleteCommentUseCase>()) {
      serviceLocator.registerLazySingleton<DeleteCommentUseCase>(
        () => DeleteCommentUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<LikeCommentUseCase>()) {
      serviceLocator.registerLazySingleton<LikeCommentUseCase>(
        () => LikeCommentUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<DislikeCommentUseCase>()) {
      serviceLocator.registerLazySingleton<DislikeCommentUseCase>(
        () => DislikeCommentUseCase(serviceLocator()),
      );
    }

    //! NEW: Playlist Dependencies
    // Data Sources
    if (!serviceLocator.isRegistered<PlaylistRemoteDataSource>()) {
      serviceLocator.registerLazySingleton<PlaylistRemoteDataSource>(
        () => PlaylistRemoteDataSourceImpl(serviceLocator()),
      );
    }

    // Repositories
    if (!serviceLocator.isRegistered<PlaylistRepository>()) {
      serviceLocator.registerLazySingleton<PlaylistRepository>(
        () => PlaylistRepositoryImpl(serviceLocator()),
      );
    }

    // Use Cases
    if (!serviceLocator.isRegistered<GetPlaylistsUseCase>()) {
      serviceLocator.registerLazySingleton<GetPlaylistsUseCase>(
        () => GetPlaylistsUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<CreatePlaylistUseCase>()) {
      serviceLocator.registerLazySingleton<CreatePlaylistUseCase>(
        () => CreatePlaylistUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<GetPlaylistByIdUseCase>()) {
      serviceLocator.registerLazySingleton<GetPlaylistByIdUseCase>(
        () => GetPlaylistByIdUseCase(serviceLocator()),
      );
    }

    // IMPORTANT: Add the missing GetPlaylistWithVideosUseCase
    if (!serviceLocator.isRegistered<GetPlaylistWithVideosUseCase>()) {
      serviceLocator.registerLazySingleton<GetPlaylistWithVideosUseCase>(
        () => GetPlaylistWithVideosUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<AddVideoToPlaylistUseCase>()) {
      serviceLocator.registerLazySingleton<AddVideoToPlaylistUseCase>(
        () => AddVideoToPlaylistUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<RemoveVideoFromPlaylistUseCase>()) {
      serviceLocator.registerLazySingleton<RemoveVideoFromPlaylistUseCase>(
        () => RemoveVideoFromPlaylistUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<DeletePlaylistUseCase>()) {
      serviceLocator.registerLazySingleton<DeletePlaylistUseCase>(
        () => DeletePlaylistUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<UpdatePlaylistUseCase>()) {
      serviceLocator.registerLazySingleton<UpdatePlaylistUseCase>(
        () => UpdatePlaylistUseCase(serviceLocator()),
      );
    }

    //! Star Cubit with all dependencies
    // استخدم registerFactory بدلاً من registerLazySingleton للـ Cubit
    serviceLocator.registerFactory<StarCubit>(
      () => StarCubit(
        // Original Star dependencies
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
        // New Tube Video dependencies
        serviceLocator<FetchAllTubeVideosUseCase>(),
        serviceLocator<FetchMyTubeVideosUseCase>(),
        serviceLocator<FetchTubeVideoDetailsByIdUseCase>(),
        serviceLocator<LikeTubeVideoUseCase>(),
        serviceLocator<DislikeTubeVideoUseCase>(),
        serviceLocator<IncrementTubeVideoViewUseCase>(),
        serviceLocator<DeleteTubeVideoUseCase>(),
      ),
    );

    //! NEW: Comment Cubit Registration
    serviceLocator.registerFactory<CommentCubit>(
      () => CommentCubit(
        serviceLocator<CreateCommentUseCase>(),
        serviceLocator<GetCommentsUseCase>(),
        serviceLocator<UpdateCommentUseCase>(),
        serviceLocator<DeleteCommentUseCase>(),
        serviceLocator<LikeCommentUseCase>(),
        serviceLocator<DislikeCommentUseCase>(),
      ),
    );

    //! UPDATED: Playlist Cubit Registration with GetPlaylistWithVideosUseCase
    serviceLocator.registerFactory<PlaylistCubit>(
      () => PlaylistCubit(
        serviceLocator<GetPlaylistsUseCase>(),
        serviceLocator<CreatePlaylistUseCase>(),
        serviceLocator<GetPlaylistByIdUseCase>(),
        serviceLocator<GetPlaylistWithVideosUseCase>(), // ADDED THIS LINE
        serviceLocator<AddVideoToPlaylistUseCase>(),
        serviceLocator<RemoveVideoFromPlaylistUseCase>(),
        serviceLocator<DeletePlaylistUseCase>(),
        serviceLocator<UpdatePlaylistUseCase>(),
      ),
    );

    //! Profile
    // Data Sources
    if (!serviceLocator.isRegistered<ProfileRemoteDataSource>()) {
      serviceLocator.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(serviceLocator()),
      );
    }

    // Repositories
    if (!serviceLocator.isRegistered<ProfileRepository>()) {
      serviceLocator.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(serviceLocator()),
      );
    }

    // Use Cases - تأكد من التنويع الصحيح للـ Generic Types
    if (!serviceLocator.isRegistered<GetMyProfileUseCase>()) {
      serviceLocator.registerLazySingleton<GetMyProfileUseCase>(
        () => GetMyProfileUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<GetProfileByIdUseCase>()) {
      serviceLocator.registerLazySingleton<GetProfileByIdUseCase>(
        () => GetProfileByIdUseCase(serviceLocator()),
      );
    }

    if (!serviceLocator.isRegistered<UpdateProfileUseCase>()) {
      serviceLocator.registerLazySingleton<UpdateProfileUseCase>(
        () => UpdateProfileUseCase(serviceLocator()),
      );
    }

    // Cubit - استخدم registerFactory للـ Cubit
    serviceLocator.registerFactory<ProfileCubit>(
      () => ProfileCubit(
        serviceLocator<GetMyProfileUseCase>(),
        serviceLocator<GetProfileByIdUseCase>(),
        serviceLocator<UpdateProfileUseCase>(),
      ),
    );
  }
}
