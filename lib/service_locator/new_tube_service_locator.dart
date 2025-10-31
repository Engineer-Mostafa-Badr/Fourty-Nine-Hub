
import 'package:fourtyninehub/features/spotlight/data/datasource/spotlight_remote_datasource.dart';
import 'package:fourtyninehub/features/spotlight/data/repositories/spotlight_repo_impl.dart';
import 'package:fourtyninehub/features/spotlight/domain/usecases/get_spotlight_use_case.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/create_video_tube_use_case.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/get_all_tube_videos_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/spotlight/domain/repositories/spotlight_repo.dart';
import '../features/spotlight/presentation/cubit/spotlight_cubit.dart';
import '../features/tube/data/datasource/tube_remote_datasource.dart';
import '../features/tube/data/repositories/tube_repo_impl.dart';
import '../features/tube/domain/repositories/tube_repo.dart';
import '../features/tube/domain/usecases/add_favorite_tube_use_case.dart';
import '../features/tube/domain/usecases/add_watch_later_tube_use_case.dart';
import '../features/tube/domain/usecases/create_comment_tube_video_use_case.dart';
import '../features/tube/domain/usecases/delete_tube_comment_use_case.dart';
import '../features/tube/domain/usecases/delete_tube_video_use_case.dart';
import '../features/tube/domain/usecases/dislike_tube_comment_use_case.dart';
import '../features/tube/domain/usecases/dislike_tube_video_use_case.dart';
import '../features/tube/domain/usecases/get_active_categories_use_case.dart';
import '../features/tube/domain/usecases/get_history_tube_videos_use_case.dart';
import '../features/tube/domain/usecases/get_my_tube_videos_use_case.dart';
import '../features/tube/domain/usecases/get_related_tube_videos_use_case.dart';
import '../features/tube/domain/usecases/get_tube_favorite_videos_use_case.dart';
import '../features/tube/domain/usecases/get_tube_video_comments_use_case.dart';
import '../features/tube/domain/usecases/like_tube_comment_use_case.dart';
import '../features/tube/domain/usecases/like_tube_video_use_case.dart';
import '../features/tube/domain/usecases/rate_tube_video_use_case.dart';
import '../features/tube/domain/usecases/remove_favorite_tube_use_case.dart';
import '../features/tube/domain/usecases/remove_watch_later_tube_use_case.dart';
import '../features/tube/domain/usecases/search_tube_use_case.dart';
import '../features/tube/domain/usecases/update_comment_tube_video_use_case.dart';
import '../features/tube/domain/usecases/update_tube_video_use_case.dart';
import '../features/tube/presentation/cubit/tube_cubit.dart';



class NewTubeServiceLocator {
  static void execute({required GetIt serviceLocator}) async {

    serviceLocator.registerLazySingleton<TubeRemoteDataSource>(() =>
        TubeRemoteDataSourceImpl(serviceLocator(),));

    serviceLocator.registerLazySingleton<GetAllTubeVideosUseCase>(
        () => GetAllTubeVideosUseCase(
              serviceLocator(),
            ));
   serviceLocator.registerLazySingleton<AddFavoriteTubeUseCase>(
        () => AddFavoriteTubeUseCase(
              serviceLocator(),
            ));
   serviceLocator.registerLazySingleton<RemoveFavoriteTubeUseCase>(
        () => RemoveFavoriteTubeUseCase(
              serviceLocator(),
            ));
   serviceLocator.registerLazySingleton<SearchTubeVideoUseCase>(
        () => SearchTubeVideoUseCase(
              serviceLocator(),
            ));

   serviceLocator.registerLazySingleton<GetRelatedTubeVideosUseCase>(
        () => GetRelatedTubeVideosUseCase(
              serviceLocator(),
            ));



    serviceLocator.registerLazySingleton<GetTubeFavoriteVideosUseCase>(
        () => GetTubeFavoriteVideosUseCase(
              serviceLocator(),
            ));



    serviceLocator.registerLazySingleton<GetTubeVideoCommentsUseCase>(
        () => GetTubeVideoCommentsUseCase(
              serviceLocator(),
            ));


    serviceLocator.registerLazySingleton<TubeRepository>(
        () => TubeRepoImpl(serviceLocator()));



    serviceLocator.registerLazySingleton<CreateCommentTubeVideoUseCase>(
        () => CreateCommentTubeVideoUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<UpdateCommentTubeVideoUseCase>(
        () => UpdateCommentTubeVideoUseCase(serviceLocator()));


    serviceLocator.registerLazySingleton<LikeTubeCommentUseCase >(
        () => LikeTubeCommentUseCase (serviceLocator()));



    serviceLocator.registerLazySingleton<DislikeTubeCommentUseCase  >(
        () => DislikeTubeCommentUseCase  (serviceLocator()));



    serviceLocator.registerLazySingleton<DeleteTubeCommentUseCase   >(
        () => DeleteTubeCommentUseCase   (serviceLocator()));


    serviceLocator.registerLazySingleton<LikeTubeVideoUseCase   >(
        () => LikeTubeVideoUseCase   (serviceLocator()));



    serviceLocator.registerLazySingleton<DislikeTubeVideoUseCase   >(
        () => DislikeTubeVideoUseCase   (serviceLocator()));


    serviceLocator.registerLazySingleton<GetActiveCategoriesUseCase   >(
        () => GetActiveCategoriesUseCase   (serviceLocator()));

    serviceLocator.registerLazySingleton<CreateVideoTubeUseCase   >(
        () => CreateVideoTubeUseCase   (serviceLocator()));



    serviceLocator.registerLazySingleton<GetMyTubeVideosUseCase   >(
        () => GetMyTubeVideosUseCase   (serviceLocator()));


    serviceLocator.registerLazySingleton<GetHistoryTubeVideosUseCase   >(
        () => GetHistoryTubeVideosUseCase   (serviceLocator()));


    serviceLocator.registerLazySingleton<DeleteTubeVideoUseCase   >(
        () => DeleteTubeVideoUseCase   (serviceLocator()));



    serviceLocator.registerLazySingleton<UpdateTubeVideoUseCase   >(
        () => UpdateTubeVideoUseCase   (serviceLocator()));


    serviceLocator.registerLazySingleton<RemoveWatchLaterTubeUseCase   >(
        () => RemoveWatchLaterTubeUseCase   (serviceLocator()));


    serviceLocator.registerLazySingleton<AddWatchLaterTubeUseCase   >(
        () => AddWatchLaterTubeUseCase   (serviceLocator()));



    serviceLocator.registerLazySingleton<RateTubeVideoUseCase   >(
        () => RateTubeVideoUseCase   (serviceLocator()));




    serviceLocator
        .registerFactory<TubeCubit>(() => TubeCubit(
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
