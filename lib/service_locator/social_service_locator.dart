import 'package:fourtyninehub/features/social_media/chat/chat_room/data/datasources/local/chat_message_local_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/datasources/remote/chat_message_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/repositories/chat_room_repository_implement.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/assign_labels_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/clear_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/create_lable_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/delete_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_lables_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_one_time_view_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_clear_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_delete_message.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_delivered_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_new_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_one_time_message_seen.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_pin_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_record_listend.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_recording_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_seen_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_typing_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_unpin_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_message_as_seen_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_messages_as_delivered_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/pin_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/set_record_as_listened.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/start_recording_uecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/start_typing_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_listen_to_delivered_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_listen_to_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_listen_to_seen_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_recording_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_typing_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/unpin_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/update_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/datasources/chats_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/repositories/chats_repository_implement.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatMuteState_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatToArchiveNormal_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/connect_me_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/delete_chat_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/disconnect_me_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getGroupsChats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getSeenHistoryUseCase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chat_last_seen_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_online_offline_status_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/listen_to_new_chat_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/lock_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/pin_chat_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/recover_deleted_chats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/show_deleted_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/unlock_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/unpin_chat_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:get_it/get_it.dart';

class SocialServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    // ---------------------------------- data sources ----------------------------------
    serviceLocator.registerLazySingleton<ChatsRemoteDataSource>(
        () => ChatsRemoteDataSourceImplementation(
              serviceLocator(),
            ));
    // serviceLocator.registerLazySingleton<MessagesRemoteDataSource>(() =>
    //     MessagesRemoteDataSourceImplementation(
    //         serviceLocator(), serviceLocator()));
    serviceLocator.registerLazySingleton<MessagesRemoteDataSource>(
        () => MessagesRemoteDataSourceImplementation(
              serviceLocator(),
            ));
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
        serviceLocator.registerLazySingleton<CreateLableUsecase>(() => CreateLableUsecase(
          serviceLocator(),
        ));
        serviceLocator.registerLazySingleton<AssignLabelsUsecase>(() => AssignLabelsUsecase(
          serviceLocator(),
        ));
    serviceLocator
        .registerLazySingleton<GetLablesUsecase>(() => GetLablesUsecase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<ConnectMeUseCase>(() => ConnectMeUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<DisconnectMeUseCase>(() => DisconnectMeUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetOnlineOfflineStatusUseCase>(
        () => GetOnlineOfflineStatusUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<RecoverDeletedChatsUseCase>(
        () => RecoverDeletedChatsUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetChatLastSeenUseCase>(
        () => GetChatLastSeenUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<DeleteMessageUseCase>(() => DeleteMessageUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ShowDeletedMessageUseCase>(
        () => ShowDeletedMessageUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ListenToDeleteMessageUseCase>(
        () => ListenToDeleteMessageUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase(
          serviceLocator(),
        ));

    serviceLocator
        .registerLazySingleton<UpdateChatUseCase>(() => UpdateChatUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetChatUseCase>(() => GetChatUseCase(
          serviceLocator(),
        ));
    serviceLocator
        .registerLazySingleton<PinMessageUseCase>(() => PinMessageUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<UnPinMessageUseCase>(() => UnPinMessageUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ListenToPinMessageUseCase>(
        () => ListenToPinMessageUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ListenToUnPinMessageUseCase>(
        () => ListenToUnPinMessageUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<ClearChatUseCase>(() => ClearChatUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ListenToClearChatUseCase>(
        () => ListenToClearChatUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ListenToOneTimeMessageSeenUseCase>(
        () => ListenToOneTimeMessageSeenUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<StartTypingMessageUseCase>(
        () => StartTypingMessageUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<ListenToRecordListened>(
        () => ListenToRecordListened(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<SetRecordAsListenedUseCase>(
        () => SetRecordAsListenedUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<StopTypingMessageUseCase>(
        () => StopTypingMessageUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ListenToTypingUseCase>(
        () => ListenToTypingUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<StartRecordingMessageUseCase>(
        () => StartRecordingMessageUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<StopRecordingMessageUseCase>(
        () => StopRecordingMessageUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ListenToRecordingUseCase>(
        () => ListenToRecordingUseCase(
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

    serviceLocator.registerLazySingleton<GetOneTimeViewMessageUseCase>(
        () => GetOneTimeViewMessageUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<ChangeChatMuteStateUseCase>(
        () => ChangeChatMuteStateUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<DeleteChatUseCase>(() => DeleteChatUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<PinChatUseCase>(() => PinChatUseCase(
          serviceLocator(),
        ));
    serviceLocator
        .registerLazySingleton<UnPinChatUseCase>(() => UnPinChatUseCase(
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

    serviceLocator.registerLazySingleton<ListenToNewMessageUseCase>(
        () => ListenToNewMessageUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<ListenToNewChatUseCase>(
        () => ListenToNewChatUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<StopListenToMessagesUseCase>(
        () => StopListenToMessagesUseCase(
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

    serviceLocator.registerLazySingleton<MarkMessageAsSeenUseCase>(
        () => MarkMessageAsSeenUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ListenToSeenMessagesUseCase>(
        () => ListenToSeenMessagesUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<StopListenToSeenMessagesUseCase>(
        () => StopListenToSeenMessagesUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<MarkMessagesAsDeliveredUseCase>(
        () => MarkMessagesAsDeliveredUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ListenToDeliveredMessagesUseCase>(
        () => ListenToDeliveredMessagesUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<StopListenToDeliveredMessagesUseCase>(
        () => StopListenToDeliveredMessagesUseCase(
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

    serviceLocator.registerFactory<ChatRoomCubit>(() => ChatRoomCubit(
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
