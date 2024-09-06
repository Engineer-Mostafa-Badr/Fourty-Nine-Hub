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
import 'package:get_it/get_it.dart';

class SocialServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    // chats

    serviceLocator.registerLazySingleton<ChatsRemoteDataSource>(
        () => ChatsRemoteDataSourceImplementation(serviceLocator()));

    serviceLocator.registerLazySingleton<ChatsRepository>(
        () => ChatsRepositoryImplementation(serviceLocator()));

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

    serviceLocator.registerLazySingleton<ChatRoomRepository>(
        () => ChatRoomRepositoryImplementation(serviceLocator()));

    serviceLocator.registerLazySingleton<ChatRemoteDataSource>(
        () => ChatRemoteDataSourceImplementation(serviceLocator()));
    serviceLocator.registerLazySingleton<GetChatMessagesUseCase>(
        () => GetChatMessagesUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<DeleteChatMessageUseCase>(
        () => DeleteChatMessageUseCase(
              serviceLocator(),
            ));
  }
}
