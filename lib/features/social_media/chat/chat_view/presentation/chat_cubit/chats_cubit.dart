import 'dart:async';
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
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chats_usecase.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ListenToNewMessageUseCase _listenToNewMessageUseCase;
  final StopListenToMessagesUseCase _stopListenToMessagesUseCase;
  final MarkMessagesAsDeliveredUseCase _markMeesagesAsDeliveredUseCase;
  final GetChatsUseCase _getChatsUseCase;
  final Map<String, ChatEntity> _chats = {};
  ChatCategories _selectedChatCategory = ChatCategories.values.first;
  late ChatEntity _selectedChat;
  List<ChatEntity> selectedChats = [];

  ChatsCubit(
    this._getChatsUseCase,
    this._listenToNewMessageUseCase,
    this._stopListenToMessagesUseCase,
    this._markMeesagesAsDeliveredUseCase,
  ) : super(const ChatsState()) {
    serviceLocator<Socket>()
        .on('getRooms', (data) => CliLogger.warning('get rooms : $data'));
  }

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
  }

  // ======================================= get chats =======================================

  Future<void> getChatsByCategory(ChatCategories chatCategory) async {
    _selectedChatCategory = chatCategory;
    switch (chatCategory) {
      case ChatCategories.social:
        return _getSocialChats();
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

  /// the [flag] parameter is used to filter the [_chats]
  Future<void> _getChats(
      {required bool Function(ChatEntity) flag,
      required GetChatsParams params}) async {
    emit(state.copyWith(status: ChatsStates.loading));

    final List<ChatEntity> chats = [];
    for (final chat in _chats.values) {
      if (flag(chat)) {
        chats.add(chat);
      }
    }
    if (chats.isEmpty) {
      final response = await _getChatsUseCase(params);
      response.fold(
          (l) => emit(state.copyWith(status: ChatsStates.error, failure: l)),
          (chats) {
        for (final chat in chats) {
          _chats[chat.id] = chat;
        }
        emit(state.copyWith(chats: chats, status: ChatsStates.success));
      });
    } else {
      emit(state.copyWith(chats: chats, status: ChatsStates.success));
    }
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

  Future<void> _getGreetChats() async {
    await _getChats(
        flag: (chat) => chat.categoryId == ChatCategoriesIds.greet,
        params: GetChatsParams(categoryId: ChatCategoriesIds.greet));
  }

  Future<void> _getAnonymousChats() async {
    await _getChats(
        flag: (chat) => chat.categoryId == ChatCategoriesIds.anonymous,
        params: GetChatsParams(privacy: ChatPrivacy.anonymous));
  }

  Future<void> _getLockedChats() async {
    await _getChats(
        flag: (chat) => chat.locked, params: GetChatsParams(isLocked: true));
  }

  Future<void> _getUnreadChats() async {
    await _getChats(
        flag: (chat) => chat.lastMessage?.seen ?? false,
        params: GetChatsParams(isUnread: true));
  }

  Future<void> _getArchivedChats() async {
    await _getChats(
        flag: (chat) => chat.archived, params: GetChatsParams(archived: true));
  }

  // ======================================= listening ========================================
  _listenToNewMessages() {
    _listenToNewMessageUseCase((message) {
      _chats[message.chatId]?.lastMessage = message;
      if (!message.byMe && message.chatId != null) {
        _markMeesagesAsDeliveredUseCase(MarkMessagesAsDeliveredParams(chatId: message.chatId!));
      }
      emit(state.copyWith(newMessage: message, status: ChatsStates.newMessage));
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
}
