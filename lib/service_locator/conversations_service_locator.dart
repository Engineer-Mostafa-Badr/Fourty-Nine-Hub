import 'package:fourtyninehub/features/Conversations/Data/DataSources/conversations_remote_datasource.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Repo/conversations_repo.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Usecases/get_socail_conversations.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Usecases/toggle_archived_conversation_usecase.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Usecases/toggle_mute_conversations_use_case.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Usecases/toggle_pinned_conversations_use_case.dart';
import 'package:fourtyninehub/features/Conversations/Presentation/Controllers/cubits/conversations_cubit.dart';

import '../features/Conversations/Data/Repo/conversations_repo_impl.dart';
import 'package:get_it/get_it.dart';

import '../features/Conversations/Domain/Usecases/delete_conversations_use_case.dart';
import '../features/Conversations/Domain/Usecases/get_social_archived_conversations_use_case.dart';
import '../features/Conversations/Domain/Usecases/get_unreaded_conversations_count_use_case.dart';
import '../features/Conversations/Domain/Usecases/listen_to_start_typing.dart';
import '../features/Conversations/Domain/Usecases/listen_to_stop_typing_usecase.dart';
import '../features/Conversations/Domain/Usecases/listen_to_update_social_list_usecase.dart';
import '../features/Conversations/Domain/Usecases/start_typing_usecase.dart';
import '../features/Conversations/Domain/Usecases/stop_typing_usecase.dart';

class ConversationsServiceLocator {
  static void execute({required GetIt serviceLocator}) {
    // ---------------------------------- data sources ----------------------------------
    serviceLocator.registerLazySingleton<ConversationsRemoteDataSource>(
        () => ConversationsRemoteDataSourceImpl(serviceLocator()));

    // ---------------------------------- repositories ----------------------------------
    serviceLocator.registerLazySingleton<ConversationsRepo>(() =>
        ConversationsRepoImpl(conversationsRemoteDataSource: serviceLocator()));

    // ---------------------------------- use cases ----------------------------------
    serviceLocator.registerLazySingleton<GetSocialConversations>(
      () => GetSocialConversations(conversationsRepo: serviceLocator()));
    serviceLocator.registerLazySingleton<GetSocialArchivedConversations>(
      () => GetSocialArchivedConversations(conversationsRepo: serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToUpdateSocialListUseCase>(
            () =>  ListenToUpdateSocialListUseCase(conversationsRepository: serviceLocator()));
    serviceLocator.registerLazySingleton<StartTypingUseCase>(
            () => StartTypingUseCase(repository: serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToStartTypingUseCase>(
            () =>  ListenToStartTypingUseCase(conversationsRepo: serviceLocator()));
    serviceLocator.registerLazySingleton<StopTypingUseCase>(
            () => StopTypingUseCase(conversationsRepository: serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToStopTypingUseCase>(
            () =>  ListenToStopTypingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ToggleArchivedConversationUseCase>(
            () =>  ToggleArchivedConversationUseCase(conversationsRepository: serviceLocator()));
    serviceLocator.registerLazySingleton<TogglePinnedConversationUseCase>(
            () =>  TogglePinnedConversationUseCase( conversationsRepository: serviceLocator()));
    serviceLocator.registerLazySingleton<ToggleMuteConversationUseCase>(
            () =>  ToggleMuteConversationUseCase( conversationsRepository: serviceLocator()));
    serviceLocator.registerLazySingleton<DeleteConversationsUseCase>(
            () =>  DeleteConversationsUseCase( conversationsRepository: serviceLocator()));
    serviceLocator.registerLazySingleton<GetUnreadConversationsUseCase>(
            () =>  GetUnreadConversationsUseCase( conversationsRepository: serviceLocator()));


    // ---------------------------------- cubits ----------------------------------

    serviceLocator.registerLazySingleton<ConversationsCubit>(
      () => ConversationsCubit(
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
      ),
    );
  }
}
