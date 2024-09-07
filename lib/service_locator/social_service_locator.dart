import 'package:fourtyninehub/features/social_media/chat/chat_room/data/datasources/local/chat_message_local_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/datasources/remote/chat_message_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/repositories/chat_room_repository_implement.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/deleteMessage_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/getChatMessages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_new_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';
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
import 'package:get_it/get_it.dart';

class SocialServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    // ---------------------------------- data sources ----------------------------------
    serviceLocator.registerLazySingleton<ChatsRemoteDataSource>(
        () => ChatsRemoteDataSourceImplementation(serviceLocator()));
    serviceLocator.registerLazySingleton<MessagesRemoteDataSource>(() =>
        MessagesRemoteDataSourceImplementation(
            serviceLocator(), serviceLocator()));
    serviceLocator.registerLazySingleton<MessagesLocalDataSource>(
        () => SQFLiteMessagesLocalDataSourceImplementation(serviceLocator()));
    // ---------------------------------- repositories ----------------------------------
    serviceLocator.registerLazySingleton<ChatRoomRepository>(() =>
        ChatRoomRepositoryImplementation(serviceLocator(), serviceLocator()));
    serviceLocator.registerLazySingleton<ChatsRepository>(
        () => ChatsRepositoryImplementation(serviceLocator()));
    // ---------------------------------- use cases ----------------------------------
    serviceLocator.registerLazySingleton<GetChatsUseCase>(() => GetChatsUseCase(
          serviceLocator(),
        ));

    serviceLocator
        .registerLazySingleton<GroupsChatsUseCase>(() => GroupsChatsUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetSeenHistoryUseCase>(
        () => GetSeenHistoryUseCase(
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

    serviceLocator
        .registerLazySingleton<UnLockChatUseCase>(() => UnLockChatUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<LockChatUseCase>(() => LockChatUseCase(
          serviceLocator(),
        ));

    // serviceLocator.registerLazySingleton<GetChatMessagesUseCase>(
    //     () => GetChatMessagesUseCase(
    //           serviceLocator(),
    //         ));

    serviceLocator.registerLazySingleton<DeleteChatMessageUseCase>(
        () => DeleteChatMessageUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<ListenToNewMessageUseCase>(
        () => ListenToNewMessageUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<SendMessageUseCase>(() => SendMessageUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<GetMessagesUseCase>(() => GetMessagesUseCase(
              serviceLocator(),
            ));
    // ---------------------------------- cubits ----------------------------------

    serviceLocator.registerFactory<ChatsCubit>(() => ChatsCubit(
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
          serviceLocator(),
        ));
  }
}
