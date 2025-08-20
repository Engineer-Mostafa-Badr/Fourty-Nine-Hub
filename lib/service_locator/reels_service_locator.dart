import '../features/social_media/reels/data/data_sources/reels_remote_data_source.dart';
import '../features/social_media/reels/data/repositories/reels_repository_impl.dart';
import '../features/social_media/reels/domain/repositories/reels_repository.dart';
import '../features/social_media/reels/domain/use_case/add_reel_comment_use_case.dart';
import '../features/social_media/reels/domain/use_case/add_reel_reply_use_case.dart';
import '../features/social_media/reels/domain/use_case/create_advertisement_use_case.dart';
import '../features/social_media/reels/domain/use_case/create_reel_use_case.dart';
import '../features/social_media/reels/domain/use_case/get_comments_use_case.dart';
import '../features/social_media/reels/domain/use_case/get_explore_reels_use_case.dart';
import '../features/social_media/reels/domain/use_case/get_followers_reels_use_case.dart';
import '../features/social_media/reels/domain/use_case/like_reel_use_case.dart';
import '../features/social_media/reels/domain/use_case/reels_with_same_audia_use_case.dart';
import '../features/social_media/reels/domain/use_case/save_reel_use_case.dart';
import '../features/social_media/reels/domain/use_case/share_reel_use_case.dart';
import '../features/social_media/reels/domain/use_case/toggle_comment_like_use_case.dart';
import '../features/social_media/reels/domain/use_case/upload_reel_use_case.dart';
import '../features/social_media/reels/domain/use_case/upload_video_reel_use_case.dart';
import '../features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import '../features/social_media/reels/presentation/controllers/preload_cubit/preload_bloc.dart';
import 'package:get_it/get_it.dart';

class ReelsServiceLocator {
  static void execute({required GetIt serviceLocator}) {
    serviceLocator.registerLazySingleton<ReelsRemoteDataSource>(
      () => ReelsRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );

    // Register the ReelsRepository
    serviceLocator.registerLazySingleton<ReelsRepository>(
      () => ReelsRepositoryImpl(serviceLocator()),
    );
    // Register the ReelsCubit

    //
    // // use cases
    serviceLocator.registerLazySingleton<CreateReelUseCase>(
      () => CreateReelUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<CreateAdvertisementUseCase>(
      () => CreateAdvertisementUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<GetExploreReelsUseCase>(
      () => GetExploreReelsUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<GetFollowingReelsUseCase>(
      () => GetFollowingReelsUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<SaveReelUseCase>(
      () => SaveReelUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<ShareReelUseCase>(
      () => ShareReelUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<LikeReelUseCase>(
      () => LikeReelUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<AddReelCommentUseCase>(
      () => AddReelCommentUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<AddReelReplyUseCase>(
      () => AddReelReplyUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<GetCommentsUseCase>(
      () => GetCommentsUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<ToggleCommentLikeUseCase>(
      () => ToggleCommentLikeUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<ReelsWithSameAudioUseCase>(
      () => ReelsWithSameAudioUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<UploadReelUseCase>(
      () => UploadReelUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<UploadVideoReelUseCase>(
      () => UploadVideoReelUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton(() => PreloadBloc());
    serviceLocator.registerLazySingleton<ReelsCubit>(
      () => ReelsCubit(
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
          serviceLocator()),
    );
  }
}
