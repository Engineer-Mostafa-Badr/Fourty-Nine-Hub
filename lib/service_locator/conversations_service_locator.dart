import 'package:fourtyninehub/features/Conversations/Data/DataSources/conversations_remote_datasource.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Repo/conversations_repo.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Usecases/get_socail_conversations.dart';
import 'package:fourtyninehub/features/Conversations/Presentation/Controllers/cubits/conversations_cubit.dart';

import '../features/Conversations/Data/Repo/conversations_repo_impl.dart';
import 'package:get_it/get_it.dart';

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

    // ---------------------------------- cubits ----------------------------------

    serviceLocator.registerLazySingleton<ConversationsCubit>(
      () => ConversationsCubit(
        serviceLocator(),
      ),
    );
  }
}
