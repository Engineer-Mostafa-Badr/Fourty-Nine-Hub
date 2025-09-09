import '../features/social_media/create_post/domain/usecases/creat_twitter_usecase.dart';
import '../features/social_media/twitter/data/datasources/twitter_remote_datasource.dart';
import '../features/social_media/twitter/data/repositories/twitter_repo_impl.dart';
import '../features/social_media/twitter/domain/repositories/twitter_repo.dart';
import '../features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import '../features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import '../features/social_media/twitter/domain/usecases/delete_twitter_comment_usecase.dart';
import '../features/social_media/twitter/domain/usecases/delete_twitter_post_usecase.dart';
import '../features/social_media/twitter/domain/usecases/edit_twitter_comment_usecase.dart';
import '../features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../features/social_media/twitter/domain/usecases/get_global_feed_usecase.dart';
import '../features/social_media/twitter/domain/usecases/get_post_comment_reply_usecase.dart';
import '../features/social_media/twitter/domain/usecases/get_post_comments_usecase.dart';
import '../features/social_media/twitter/domain/usecases/get_twitter_post_usecase.dart';
import '../features/social_media/twitter/domain/usecases/get_user_posts_usecase.dart';
import '../features/social_media/twitter/domain/usecases/hide_twitter_post_usecase.dart';
import '../features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import '../features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import '../features/social_media/twitter/domain/usecases/request_document_usecase.dart';
import '../features/social_media/twitter/domain/usecases/share_twitter_post_usecase.dart';
import '../features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import '../features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:get_it/get_it.dart';

class TwitterServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<TwitterRemoteDataSource>(
        () => TwitterRemoteDataSourceImpl(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<TwitterRepo>(
        () => TwitterRepoImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<GetTwitterFeedUseCase>(
        () => GetTwitterFeedUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<TwitterPostReactUseCase>(
        () => TwitterPostReactUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetTwitterPostCommentsUseCase>(
        () => GetTwitterPostCommentsUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<CreateTwitterPostUseCase>(
        () => CreateTwitterPostUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<TwitterCommentReactUseCase>(
        () => TwitterCommentReactUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetTwitterPostUseCase>(
        () => GetTwitterPostUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<TwitterSharePostUseCase>(
        () => TwitterSharePostUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<TwitterPostCommentUseCase>(
        () => TwitterPostCommentUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<TwitterCommentReplyUseCase>(
        () => TwitterCommentReplyUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetTwitterCommentRepliesUseCase>(
        () => GetTwitterCommentRepliesUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<TwitterReportUseCase>(() => TwitterReportUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<RequestDocumentUseCase>(
        () => RequestDocumentUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<GetUserTweetsUseCase>(() => GetUserTweetsUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<HideTwitterPostUseCase>(
        () => HideTwitterPostUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<DeleteTwitterPostUseCase>(
        () => DeleteTwitterPostUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<EditTwitterCommentUseCase>(
        () => EditTwitterCommentUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<DeleteTwitterCommentUseCase>(
        () => DeleteTwitterCommentUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetTwitterGlobalFeedUseCase>(
        () => GetTwitterGlobalFeedUseCase(
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
          serviceLocator(),
        ));
  }
}
