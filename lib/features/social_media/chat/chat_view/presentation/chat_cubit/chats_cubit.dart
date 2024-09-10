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
  final GetChatsUseCase _getChatsUseCase;
  final ListenToNewMessageUseCase _listenToNewMessageUseCase;
  final StopListenToMessagesUseCase _stopListenToMessagesUseCase;
  late ChatCategories selectedChatCategory;
  late String lockChatPassword;
  final Map<String, ChatEntity> _chats = {};
  late ChatEntity _selectedChat;

  ChatsCubit(
    this._getChatsUseCase,
    this._listenToNewMessageUseCase,
    this._stopListenToMessagesUseCase,
  ) : super(const ChatsState());

  init() async {
    _listenToNewMessages();
    getSocialChats();
  }

  Future<void> getSocialChats() async {
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
