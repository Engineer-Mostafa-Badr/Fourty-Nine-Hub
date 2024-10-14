import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/chat_categories.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/seen_history_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_new_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_messages_as_delivered_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_listen_to_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatMuteState_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatToArchiveNormal_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/delete_chat_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/listen_to_new_chat_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/pin_chat_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/unpin_chat_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ListenToNewChatUseCase _listenToNewChatUseCase;
  final ListenToNewMessageUseCase _listenToNewMessageUseCase;
  final StopListenToMessagesUseCase _stopListenToMessagesUseCase;
  final MarkMessagesAsDeliveredUseCase _markMeesagesAsDeliveredUseCase;
  final GetChatsUseCase _getChatsUseCase;
  final DeleteChatUseCase _deleteChatUseCase;
  final PinChatUseCase _pinChatUseCase;
  final UnPinChatUseCase _unPinChatUseCase;
  final ChangeChatToArchiveOrNormalUseCase _changeChatToArchiveOrNormalUseCase;
  final ChangeChatMuteStateUseCase _changeChatMuteStateUseCase;
  final Map<String, ChatEntity> _chats = {};
  ChatCategories _selectedChatCategory = ChatCategories.values.first;
  late ChatEntity _selectedChat;
  List<ChatEntity> selectedChats = [];

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
    await getChatsByCategory(_selectedChatCategory);

    _listenToNewMessages();
    _listenToNewChat();
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
      (fetchedChats) {
        final List<ChatEntity> pinnedChatList = [];
        final List<ChatEntity> unpinnedChatList = [];

        for (final chat in fetchedChats) {
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
        flag: (chat) => chat.locked, params: GetChatsParams(isLocked: true));
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
    _listenToNewChatUseCase((chat) {
      log("new chat = $chat");
      // _chats[chat.id] = chat;
      // if (!message.byMe && message.chatId != null) {
      //   _markMeesagesAsDeliveredUseCase(MarkMessagesAsDeliveredParams(chatId: message.chatId!));
      // }
      emit(state.copyWith(status: ChatsStates.success));
      getChatsByCategory(_selectedChatCategory);
    });
  }

  set selectChat(ChatEntity chat) {
    _selectedChat = chat;
  }

  ChatEntity get selectedChat => _selectedChat;

  @override
  Future<void> close() {
    _stopListenToMessagesUseCase(const NoParams());
    return super.close();
  }

  Future<void> changeArchiveChat() async {
    for (var chat in selectedChats) {
      // chat.archived = !chat.archived;
      log("archived = ${chat.archived}");
      final respons = await _changeChatToArchiveOrNormalUseCase(chat.id);
      respons.fold((l) => null, (r) {
        if (_chats.containsKey(chat.id)) {
          _chats[chat.id]?.archived = !(_chats[chat.id]!.archived);
        }
      });
      chat.isSelected = false; // setter getter in chatsEntity
    }
    selectedChats.clear();
    await getArchivedChats();
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

  // Local Storage
  // Future<void> pinAndUnpinChat() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // Retrieve the current list of pinned chat IDs from SharedPreferences
  //   List<String> pinnedChats = prefs.getStringList('pinnedChats') ?? [];

  //   for (var chat in selectedChats) {
  //     log("toggle pin/unpin = ${chat.id}");

  //     if (pinnedChats.contains(chat.id)) {
  //       // If the chat is already pinned, unpin it
  //       pinnedChats.remove(chat.id);
  //       chat.isPinned = false; // Update the pinned status in your ChatEntity
  //       log("unpin = ${chat.id}");
  //     } else {
  //       // If the chat is not pinned, pin it
  //       pinnedChats.add(chat.id);
  //       chat.isPinned = true; // Update the pinned status in your ChatEntity
  //       log("pin = ${chat.id}");
  //     }

  //     chat.isSelected = false; // Reset the selection status
  //   }

  //   // Save the updated list of pinned chat IDs back to SharedPreferences
  //   await prefs.setStringList('pinnedChats', pinnedChats);

  //   // Clear selected chats after action is complete
  //   selectedChats.clear();

  //   // Refresh the chat list by category
  //   await getChatsByCategory(_selectedChatCategory);
  // }

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
}
