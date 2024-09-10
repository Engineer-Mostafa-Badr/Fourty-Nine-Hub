import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/chat_categories.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/data/datasources/remote/socket/socket_data_source.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/seen_history_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_new_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_listen_to_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_model.dart';
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

  initChat() async {
    // await getChats(category: ChatCategories.social);
  }

  Future<void> getSocialChats() async {
    final result = await _getChatsUseCase(
        GetChatsParams(categoryId: ChatCategoriesIds.social));
    result.fold(
        (l) => emit(state.copyWith(status: ChatsStates.error, failure: l)),
        (chats) {
          for(final chat in chats){
            _chats[chat.id] = chat;
          }
          emit(state.copyWith(chats: chats, status: ChatsStates.success));
        });
  }

  // getChats({required ChatCategories category, String? password}) async {
  //   selectedChatCategory = category;
  //
  //   // if this locked chat tab & password null return empty list
  //   if (category == ChatCategories.locked && password == null) {
  //     return emit.call(state.copyWith(chats: [], status: ChatsStates.success));
  //   }
  //   GetChatsParams chatsRequestParams = GetChatsParams(
  //       categoryId: ChatCategoriesIds.social, privacy: ChatPrivacy.normal);
  //   // getTabParams(category: category, password: password);
  //
  //   if (chatsRequestParams.categoryId == null &&
  //       category != ChatCategories.groups) {
  //     return emit.call(state.copyWith(chats: [], status: ChatsStates.success));
  //   } else {
  //     _chats.clear();
  //     var response;
  //     // if (category == ChatCategories.groups) {
  //     //   response = await _groupsChatsUseCase.call(const NoParams());
  //     // } else {
  //     response = await _getChatsUseCase.call(
  //       chatsRequestParams,
  //     );
  //     // }
  //
  //     response.fold(
  //         (failure) => emit.call(
  //             state.copyWith(failure: failure, status: ChatsStates.error)),
  //         (data) async {
  //       data.chats!
  //           .map((e) => _chats.update(e.id!, (value) => e, ifAbsent: () => e))
  //           .toList();
  //
  //       // to listen typing and online emit event status
  //       List<UserStatusParams> userStatusParams = [];
  //       for (var item in _chats.values) {
  //         userStatusParams
  //             .add(UserStatusParams(chatId: item.id, userId: item.userId));
  //       }
  //
  //       await Future.delayed(const Duration(seconds: 1));
  //       sendUserStatus(userStatusParams);
  //       unReadMessage = 0;
  //
  //       return emit.call(
  //           state.copyWith(chats: data.chats, status: ChatsStates.success));
  //     });
  //   }
  // }

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
