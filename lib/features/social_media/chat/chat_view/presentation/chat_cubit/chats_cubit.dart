import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/chat_categories.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/seen_history_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_new_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_listen_to_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chats_usecase.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ListenToNewMessageUseCase _listenToNewMessageUseCase;
  final StopListenToMessagesUseCase _stopListenToMessagesUseCase;
  final GetChatsUseCase _getChatsUseCase;
  final Map<String, ChatEntity> _chats = {};
  late ChatCategories selectedChatCategory;
  late String lockChatPassword;
  late ChatEntity _selectedChat;

  ChatsCubit(
    this._getChatsUseCase,
    this._listenToNewMessageUseCase,
    this._stopListenToMessagesUseCase,
  ) : super(const ChatsState());

  init() async {
    _listenToNewMessages();
    getChats(ChatCategories.values.first);
  }

  // ======================================= get chats =======================================

  Future<void> getChats(ChatCategories chatCategories) async {
    switch (chatCategories) {
      case ChatCategories.social:
        return _getServicesChats();
      case ChatCategories.greet:
        return _getGreetChats();
      case ChatCategories.service:
        return _getServicesChats();
      case ChatCategories.anonymous:
        return _getAnonymousChats();
      case ChatCategories.locked:
        return _getLockedChats();
      case ChatCategories.unread:
        return _getUnreadChats();
      case ChatCategories.archived:
        return _getArchivedChats();
      default:
        return _getSocialChats();
    }
  }

  Future<void> _getSocialChats() async {
    final result = await _getChatsUseCase(
        GetChatsParams(categoryId: ChatCategoriesIds.social));
    result.fold(
        (l) => emit(state.copyWith(status: ChatsStates.error, failure: l)),
        (chats) {
      for (final chat in chats) {
        _chats[chat.id] = chat;
      }
      emit(state.copyWith(chats: chats, status: ChatsStates.success));
    });
  }

  Future<void> _getServicesChats() async {
    final result = await _getChatsUseCase(GetChatsParams(isServices: true));
    result.fold(
        (l) => emit(state.copyWith(status: ChatsStates.error, failure: l)),
        (chats) {
      for (final chat in chats) {
        _chats[chat.id] = chat;
      }
      emit(state.copyWith(chats: chats, status: ChatsStates.success));
    });
  }

  Future<void> _getGreetChats() async {
    final result = await _getChatsUseCase(
        GetChatsParams(categoryId: ChatCategoriesIds.greet));
    result.fold(
        (l) => emit(state.copyWith(status: ChatsStates.error, failure: l)),
        (chats) {
      for (final chat in chats) {
        _chats[chat.id] = chat;
      }
      emit(state.copyWith(chats: chats, status: ChatsStates.success));
    });
  }

  Future<void> _getAnonymousChats() async {
    final result =
        await _getChatsUseCase(GetChatsParams(privacy: ChatPrivacy.anonymous));
    result.fold(
        (l) => emit(state.copyWith(status: ChatsStates.error, failure: l)),
        (chats) {
      for (final chat in chats) {
        _chats[chat.id] = chat;
      }
      emit(state.copyWith(chats: chats, status: ChatsStates.success));
    });
  }

  Future<void> _getLockedChats() async {
    final result = await _getChatsUseCase(GetChatsParams(isLocked: true));
    result.fold(
        (l) => emit(state.copyWith(status: ChatsStates.error, failure: l)),
        (chats) {
      for (final chat in chats) {
        _chats[chat.id] = chat;
      }
      emit(state.copyWith(chats: chats, status: ChatsStates.success));
    });
  }

  Future<void> _getUnreadChats() async {
    final result = await _getChatsUseCase(GetChatsParams(isUnread: true));
    result.fold(
        (l) => emit(state.copyWith(status: ChatsStates.error, failure: l)),
        (chats) {
      for (final chat in chats) {
        _chats[chat.id] = chat;
      }
      emit(state.copyWith(chats: chats, status: ChatsStates.success));
    });
  }

  Future<void> _getArchivedChats() async {
    final result = await _getChatsUseCase(GetChatsParams(archived: true));
    result.fold(
        (l) => emit(state.copyWith(status: ChatsStates.error, failure: l)),
        (chats) {
      for (final chat in chats) {
        _chats[chat.id] = chat;
      }
      emit(state.copyWith(chats: chats, status: ChatsStates.success));
    });
  }

  // ======================================= listening ========================================
  _listenToNewMessages() {
    _listenToNewMessageUseCase((message) {
      emit(state.copyWith(newMessage: message, status: ChatsStates.newMessage));
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
}
