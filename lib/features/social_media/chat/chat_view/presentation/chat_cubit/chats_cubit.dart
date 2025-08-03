import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/data/datasources/remote/socket/socket_data_source.dart';
import '../../../../../../core/enums/chat_categories.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../authentication/domain/entities/user_entity.dart';
import '../../../chat_room/data/models/seen_history_model.dart';
import '../../../chat_room/domain/entities/message_entity.dart';
import '../../../chat_room/domain/usecases/listen_to_new_message_usecase.dart';
import '../../../chat_room/domain/usecases/listen_to_recording_usecase.dart';
import '../../../chat_room/domain/usecases/listen_to_typing_usecase.dart';
import '../../../chat_room/domain/usecases/mark_messages_as_delivered_usecase.dart';
import '../../../chat_room/domain/usecases/stop_listen_to_messages.dart';
import '../../../chat_room/domain/usecases/update_chat_usecase.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/usecases/changeChatMuteState_usecase.dart';
import '../../domain/usecases/changeChatToArchiveNormal_usecase.dart';
import '../../domain/usecases/connect_me_usecase.dart';
import '../../domain/usecases/delete_chat_use_case.dart';
import '../../domain/usecases/disconnect_me_usecase.dart';
import '../../domain/usecases/get_chat_last_seen_usecase.dart';
import '../../domain/usecases/get_chats_usecase.dart';
import '../../domain/usecases/get_online_offline_status_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/listen_to_new_chat_use_case.dart';
import '../../domain/usecases/pin_chat_use_case.dart';
import '../../domain/usecases/recover_deleted_chats_usecase.dart';
import '../../domain/usecases/unpin_chat_use_case.dart';
import '../../../../../../shared_web_socket.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ListenToNewChatUseCase _listenToNewChatUseCase;
  final ListenToNewMessageUseCase _listenToNewMessageUseCase;
  final ListenToTypingUseCase _listenToTypingUseCase;
  final ListenToRecordingUseCase _listenToRecordingUseCase;
  final StopListenToMessagesUseCase _stopListenToMessagesUseCase;
  final MarkMessagesAsDeliveredUseCase _markMeesagesAsDeliveredUseCase;
  final GetChatsUseCase _getChatsUseCase;
  final DeleteChatUseCase _deleteChatUseCase;
  final GetUserUseCase _getUserUseCase;
  final RecoverDeletedChatsUseCase _recoverDeletedChatsUseCase;
  final PinChatUseCase _pinChatUseCase;
  final UnPinChatUseCase _unPinChatUseCase;
  final ConnectMeUseCase _connectMeUseCase;
  final DisconnectMeUseCase _disconnectMeUseCase;
  final GetOnlineOfflineStatusUseCase _getOnlineOfflineStatusUseCase;
  final UpdateChatUseCase _updateChatUseCase;
  final GetChatLastSeenUseCase _getChatLastSeenUseCase;
  final ChangeChatToArchiveOrNormalUseCase _changeChatToArchiveOrNormalUseCase;
  final ChangeChatMuteStateUseCase _changeChatMuteStateUseCase;
  final Map<String, ChatEntity> _chats = {};
  ChatCategories _selectedChatCategory = ChatCategories.values.first;
  late ChatEntity _selectedChat;
  List<ChatEntity> selectedChats = [];
  UserEntity? user;
  List<LastSeenChatsEntity> lastSeenChats = [];

  ChatsCubit(
    this._getChatsUseCase,
    this._listenToNewMessageUseCase,
    this._stopListenToMessagesUseCase,
    this._markMeesagesAsDeliveredUseCase,
    this._changeChatToArchiveOrNormalUseCase,
    this._changeChatMuteStateUseCase,
    this._deleteChatUseCase,
    this._pinChatUseCase,
    this._unPinChatUseCase,
    this._listenToNewChatUseCase,
    this._listenToTypingUseCase,
    this._listenToRecordingUseCase,
    this._updateChatUseCase,
    this._getUserUseCase,
    this._getChatLastSeenUseCase,
    this._recoverDeletedChatsUseCase,
    this._connectMeUseCase,
    this._disconnectMeUseCase,
    this._getOnlineOfflineStatusUseCase,
  ) : super(const ChatsState());

  // Selected Chats
  void addChatToSelectedChats({required ChatEntity chat}) {
    selectedChats.add(chat);
    chat.isSelected = true;
    emit(state.copyWith(status: ChatsStates.chatsSelected));
  }

  void removeChatToSelectedChats({required ChatEntity chat}) {
    selectedChats.removeWhere((chatIterator) => chatIterator.id == chat.id);
    chat.isSelected = false;
    emit(state.copyWith(status: ChatsStates.chatsSelected));
  }

  Future<void> init() async {
    log("init chats cubit");
    await getChatsByCategory(_selectedChatCategory);

    _listenToNewMessages();
    _listenToNewChat();
    _listenToTyping();
    _listenToRecording();
    connectMe();
    SharedWebSocket.socket!.on("error", (date) {
      log("error from socket : $date");
    });
  }

  // ======================================= get chats =======================================

  Future<void> getChatsByCategory(ChatCategories chatCategory) async {
    _selectedChatCategory = chatCategory;
    switch (chatCategory) {
      case ChatCategories.social:
        return _getSocialChats();
      // case ChatCategories.greet:
      // return getGreetChats();
      case ChatCategories.service:
        return _getServicesChats();
      // case ChatCategories.anonymous:
      // return getAnonymousChats();
      // case ChatCategories.locked:
      // return getLockedChats();
      case ChatCategories.unread:
        return _getUnreadChats();
      // case ChatCategories.archived:
      // return getArchivedChats();
      default:
        return _getSocialChats();
    }
  }

  // /// the [flag] parameter is used to filter the [_chats]
  // Future<void> _getChats(
  //     {required bool Function(ChatEntity) flag,
  //     required GetChatsParams params}) async {
  //   emit(state.copyWith(status: ChatsStates.loading));

  //   final List<ChatEntity> chats = [];
  //   for (final chat in _chats.values) {
  //     if (flag(chat)) {
  //       chats.add(chat);
  //     }
  //   }
  //   if (chats.isEmpty) {
  //     final response = await _getChatsUseCase(params);
  //     response.fold(
  //         (l) => emit(state.copyWith(status: ChatsStates.error, failure: l)),
  //         (chats) {
  //       for (final chat in chats) {
  //         _chats[chat.id] = chat;
  //       }
  //       emit(state.copyWith(chats: chats, status: ChatsStates.success));
  //     });
  //   } else {
  //     emit(state.copyWith(chats: chats, status: ChatsStates.success));
  //   }
  // }

  Future<void> _getChats(
      {required bool Function(ChatEntity) flag,
      required GetChatsParams params}) async {
    emit(state.copyWith(status: ChatsStates.loading));

    // Always fetch fresh chats from the use case
    final response = await _getChatsUseCase(params);
    response.fold(
      (l) => emit(state.copyWith(status: ChatsStates.error, failure: l)),
      (fetchedChats) async {
        final List<ChatEntity> pinnedChatList = [];
        final List<ChatEntity> unpinnedChatList = [];

        for (final chat in fetchedChats) {
          await getOnlineOfflineStatus(chat: chat);

          log(chat.isPinned.toString());
          // Add to the corresponding list based on pinned status
          if (chat.isPinned) {
            pinnedChatList.add(chat);
          } else {
            unpinnedChatList.add(chat);
          }

          // Update the local _chats map with the fresh data
          _chats[chat.id] = chat;
        }

        // Combine pinned and unpinned chats, with pinned chats appearing first
        final sortedChats = [...pinnedChatList, ...unpinnedChatList];
        // print('sortedChats[0].lastMessage?.media.length ${sortedChats[1].lastMessage!.media.length}');
        // print('sortedChats[0].lastMessage?.media[0].type ${sortedChats[1].lastMessage!.media[0].type}');

        // Emit the sorted chat list
        emit(state.copyWith(chats: sortedChats, status: ChatsStates.success));
      },
    );
  }

  Future<void> _getSocialChats() async {
    await _getChats(
        flag: (chat) => chat.categoryId == ChatCategoriesIds.social,
        params: GetChatsParams(categoryId: ChatCategoriesIds.social));
  }

  Future<void> _getServicesChats() async {
    await _getChats(
        flag: (chat) => chat.isService,
        params: GetChatsParams(isServices: true));
  }

  Future<void> getGreetChats() async {
    await _getChats(
        flag: (chat) => chat.categoryId == ChatCategoriesIds.greet,
        params: GetChatsParams(categoryId: ChatCategoriesIds.greet));
  }

  Future<void> getAnonymousChats() async {
    await _getChats(
        flag: (chat) => chat.categoryId == ChatCategoriesIds.anonymous,
        params: GetChatsParams(privacy: ChatPrivacy.anonymous));
  }

  Future<void> getLockedChats() async {
    await _getChats(
        flag: (chat) => chat.locked,
        params: GetChatsParams(isLocked: true)); // send pass in params
  }

  Future<void> _getUnreadChats() async {
    await _getChats(
        flag: (chat) =>
            (chat.lastMessage?.seen ?? false) &&
            (!(chat.lastMessage?.byMe ?? true)),
        params: GetChatsParams(isUnread: true));
  }

  Future<void> getArchivedChats() async {
    await _getChats(
        flag: (chat) => chat.archived, params: GetChatsParams(archived: true));
  }

  // ======================================= listening ========================================
  _listenToNewMessages() {
    _listenToNewMessageUseCase((message) {
      log("new message = $message");
      _chats[message.chatId]?.lastMessage = message;
      _chats[message.chatId]?.unreadCount =
          _chats[message.chatId]?.unreadCount ?? 0 + 1;
      // if (!message.byMe && message.chatId != null) {
      //   _markMeesagesAsDeliveredUseCase(MarkMessagesAsDeliveredParams(chatId: message.chatId!));
      // }
      // emit(state.copyWith(status: ChatsStates.success));
      emit(state.copyWith(newMessage: message, status: ChatsStates.newMessage));
      // getChatsByCategory(_selectedChatCategory);
    });
  }

  _listenToNewChat() {
    _listenToNewMessageUseCase((message) {
      log("new message = $message");
      _chats[message.chatId]?.lastMessage = message;
      _chats[message.chatId]?.unreadCount =
          _chats[message.chatId]?.unreadCount ?? 0 + 1;
      // if (!message.byMe && message.chatId != null) {
      //   _markMeesagesAsDeliveredUseCase(MarkMessagesAsDeliveredParams(chatId: message.chatId!));
      // }
      // emit(state.copyWith(status: ChatsStates.success));
      emit(state.copyWith(newMessage: message, status: ChatsStates.newMessage));
      // getChatsByCategory(_selectedChatCategory);
    });
  }

  _listenToTyping() {
    _listenToTypingUseCase((listenToTypingParams) {
      log("listenToTypingParams = ${listenToTypingParams.isTyping} , chatId = ${listenToTypingParams.chatId}");
      _chats[listenToTypingParams.chatId]?.typing =
          listenToTypingParams.isTyping;
      log("listenToTypingParams after set = ${_chats[listenToTypingParams.chatId]?.typing} , name = ${_chats[listenToTypingParams.chatId]?.name}}");
      emit(state.copyWith(
          listenToTypingParams: listenToTypingParams,
          status: ChatsStates.typing));
    });
  }

  _listenToRecording() {
    _listenToRecordingUseCase((listenToRecordingParams) {
      log("listenToRecordingParams = ${listenToRecordingParams.isRecording} , chatId = ${listenToRecordingParams.chatId}");
      _chats[listenToRecordingParams.chatId]?.recording =
          listenToRecordingParams.isRecording;
      log("listenToRecording after ser = ${_chats[listenToRecordingParams.chatId]?.recording} , name = ${_chats[listenToRecordingParams.chatId]?.name}");
      emit(state.copyWith(
          listenToRecordingParams: listenToRecordingParams,
          status: ChatsStates.recording));
    });
  }

  set selectChat(ChatEntity chat) {
    _selectedChat = chat;
  }

  ChatEntity get selectedChat => _selectedChat;

  @override
  Future<void> close() {
    _stopListenToMessagesUseCase(const NoParams());
    SharedWebSocket.socket!.off(SocketIOListeners.typingMessage);
    SharedWebSocket.socket!.off(SocketIOListeners.recordingMessage);
    SharedWebSocket.socket!.off(SocketIOListeners.creatingNewChat);
    disconnectMe();
    return super.close();
  }

  Future<void> changeArchiveChat({required bool isArchivedTab}) async {
    for (var chat in selectedChats) {
      // chat.archived = !chat.archived;
      log("archived = ${chat.archived}");
      // final respons = await _changeChatToArchiveOrNormalUseCase(chat.id);
      // respons.fold((l) => null, (r) {
      //   // if (_chats.containsKey(chat.id)) {
      //   //   _chats[chat.id]?.archived = !(_chats[chat.id]!.archived);
      //   // }
      // });
      if (_chats.containsKey(chat.id)) {
        _chats[chat.id]?.archived = !(_chats[chat.id]!.archived);
      }
      chat.isSelected = false; // setter getter in chatsEntity
    }
    emit(state.copyWith(
      status: ChatsStates.success,
    ));
    for (var chat in selectedChats){
      await _changeChatToArchiveOrNormalUseCase(chat.id);
    }


    // if (isArchivedTab) {
    //   await getArchivedChats();
    // } else {
    //   await getChatsByCategory(_selectedChatCategory);
    // }
  }

  void clearSelectedChats(){
    for(ChatEntity chat in selectedChats){
      chat.isSelected = false;
    }
    selectedChats.clear();
    emit(state.copyWith(
      status: ChatsStates.success,
    ));
  }

  Future<void> changeMuteChat() async {
    for (var chat in selectedChats) {
      // chat.archived = !chat.archived;
      log("muted = ${chat.muted}");
      final respons = await _changeChatMuteStateUseCase(chat.id);
      respons.fold((l) => null, (r) {
        if (_chats.containsKey(chat.id)) {
          _chats[chat.id]?.muted = !(_chats[chat.id]!.muted);
        }
      });
      chat.isSelected = false; // setter getter in chatsEntity
    }
    selectedChats.clear();
    await getChatsByCategory(_selectedChatCategory);
  }

  Future<void> deleteChat() async {
    for (var chat in selectedChats) {
      log("delete = ${chat.id}");
      final respons = await _deleteChatUseCase(chat.id);
      respons.fold((l) => null, (r) {
        if (_chats.containsKey(chat.id)) {
          _chats.remove(chat.id);
        }
      });
      chat.isSelected = false; // setter getter in chatsEntity
    }
    selectedChats.clear();
    await getChatsByCategory(_selectedChatCategory);
  }

  Future<void> recoverDeletedChats() async {
    final respons = await _recoverDeletedChatsUseCase(const NoParams());
    respons.fold((l) => null, (r) async {
      log("recoverDeletedChats = $r");
      await getChatsByCategory(_selectedChatCategory);
    });
  }

  Future<void> connectMe() async {
    final respons = await _connectMeUseCase(const NoParams());
    respons.fold((l) => null, (r) async {
      log("connectMe = $r");
    });
  }

  Future<void> disconnectMe() async {
    final respons = await _disconnectMeUseCase(const NoParams());
    respons.fold((l) => null, (r) async {
      log("disconnectMe = $r");
    });
  }

  Future<void> getUser() async {
    final respons = await _getUserUseCase(selectedChat.userId);
    respons.fold((l) => null, (r) {
      log("user = ${r.email}");
      user = r;
    });
    emit(state.copyWith(
      status: ChatsStates.success,
    ));
  }

  Future<void> getOnlineOfflineStatus({required ChatEntity chat}) async {
    if(chat.isAdmin == 'admin') return;
    final respons = await _getOnlineOfflineStatusUseCase(chat.userId);
    respons.fold((l) => null, (r) {
      log("status = ${r.status}");
      log("formattedDate = ${r.formatDate}");

      chat.lastSeen = r.status == "online" ? "Online" : r.formatDate;
      log("lastSeen is equal to = ${chat.lastSeen}");
      chat.online = (chat.lastSeen != "" && chat.lastSeen == "Online");
    });
  }

  Future<void> getChatLastSeen({required String chatId}) async {
    lastSeenChats.clear();
    final respons = await _getChatLastSeenUseCase(chatId);
    respons.fold((l) => null, (r) {
      lastSeenChats.addAll(r);
    });
    emit(state.copyWith(
      status: ChatsStates.success,
    ));
  }

  // Remote Storage
  Future<void> pinAndUnpinChat() async {
    for (var chat in selectedChats) {
      log("toggle pin/unpin = ${chat.id}");

      if (chat.isPinned) {
        // If the chat is already pinned, unpin it
        final respons = await _unPinChatUseCase(chat.id);
        respons.fold((l) => null, (r) {
          chat.isPinned = false; // Update the pinned status in your ChatEntity
          log("unpin = ${chat.id}");
        });
      } else {
        // If the chat is not pinned, pin it
        final respons = await _pinChatUseCase(chat.id);
        respons.fold((l) => null, (r) {
          chat.isPinned = true; // Update the pinned status in your ChatEntity
          log("pin = ${chat.id}");
        });
      }

      chat.isSelected = false; // Reset the selection status
    }

    // Clear selected chats after action is complete
    selectedChats.clear();

    // Refresh the chat list by category
    await getChatsByCategory(_selectedChatCategory);
  }

  Future<void> updateChat({required ChatEntity chat}) async {
    final response = await _updateChatUseCase(
      UpdateChatParams(
        chatId: chat.id,
        isTimerActive: !chat.isTimerActive,
      ),
    );
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: ChatsStates.error)),
        (data) {
      log("update chat result $data");
      chat.isTimerActive = !chat.isTimerActive;
      emit(state.copyWith(status: ChatsStates.success));
    });
  }

  Future<void> updateLockChat({required ChatEntity chat}) async {
    final response = await _updateChatUseCase(
      UpdateChatParams(
        chatId: chat.id,
        isTimerActive: chat.isTimerActive,
        isLocked: !chat.locked,
        updateLockedChat: true,
      ),
    );
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: ChatsStates.error)),
        (data) {
      log("update lock chat result $data");
      chat.locked = !chat.locked;
      emit(state.copyWith(status: ChatsStates.success));
    });
  }

  Future<void> lockChats({required bool isLockedTap}) async {
    // for (var chat in selectedChats) {
    //   final response = await _updateChatUseCase(
    //     UpdateChatParams(
    //       chatId: chat.id,
    //       isLocked: !chat.locked,
    //       isTimerActive: chat.isTimerActive,
    //       updateLockedChat: true,
    //     ),
    //   );
    //   response.fold(
    //       (failure) =>
    //           emit(state.copyWith(failure: failure, status: ChatsStates.error)),
    //       (data) {
    //     log("lock chats result $data");
    //     chat.locked = !chat.locked;
    //     emit(state.copyWith(status: ChatsStates.success));
    //   });
    //
    //   chat.isSelected = false; // Reset the selection status
    // }
    //
    // // Clear selected chats after action is complete
    // selectedChats.clear();
    //
    // // Refresh the chat list by category
    // if (isLockedTap) {
    //   await getLockedChats();
    // } else {
    //   await getChatsByCategory(_selectedChatCategory);
    // }

    for (var chat in selectedChats){
      chat.locked = !chat.locked;
    }
    emit(state.copyWith(status: ChatsStates.success));
    for (var chat in selectedChats){
    await _updateChatUseCase(
      UpdateChatParams(
        chatId: chat.id,
        isLocked: !chat.locked,
        isTimerActive: chat.isTimerActive,
        updateLockedChat: true,
      ),
    );}
  }
}
