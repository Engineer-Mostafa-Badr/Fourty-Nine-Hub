import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/service/socket_service.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_user_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/chat_messgaes_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/typing_and_online_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/deleteMessage_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/delete_message_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/getChatMessages_usecase.dart';

part 'chat_view_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final GetTokensUseCase _getTokensUseCase;
  final GetChatMessagesUseCase _getChatMessagesUseCase;
  final GetUserUseCase _getUserUseCase;
  final DeleteChatMessageUseCase _deleteChatMessageUseCase;
  final SocketServiceContract _socketService;
  List<MessageEntity> chatMessages = [];
  ChatMessagesModel chatMessagesModel = ChatMessagesModel();
  final ScrollController? scrollController = ScrollController();

  String? userToken;
  String? userId;
  String? chatId;

  ChatRoomCubit(
    this._getTokensUseCase,
    this._getChatMessagesUseCase,
    this._deleteChatMessageUseCase,
    this._getUserUseCase,
    this._socketService,
  ) : super(const ChatRoomState());

  Future<String?> getUserToken() async {
    return _getTokensUseCase(const NoParams()).then((value) {
      return value.fold((l) => null, (r) => r?.accessToken);
    });
  }

  _joinRoom(String chatId) async {
    _socketService.joinRoom(chatId);
  }

  // BehaviorSubject<List<MessageEntity>> messages =
  //     BehaviorSubject<List<MessageEntity>>();

  getChatMessages(String chatID) async {
    chatId = chatID;
    final response = await _getChatMessagesUseCase.call(chatID);
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: ChatRoomStates.error)),
        (data) {
      chatMessages = data.messages ?? [];
      chatMessagesModel = data;

      emit(state.copyWith(
          chatData: data,
          chatMessages: data.messages!,
          status: ChatRoomStates.initState));
    });


    Timer(
        const Duration(milliseconds: 200),
            () => scrollController!
            .jumpTo(scrollController!.position.maxScrollExtent));

    // to listen new message
    listenToNewMessages();
  }

  sendMessage({required String message, String? replyMessageId}) {
    if (chatId != null) {
      _socketService.sendMessage(
          message: message, chatId: chatId!, replyMessageId: replyMessageId);
      // emit.call(state.copyWith(
      //     chatData: chatMessagesModel,
      //     chatMessages: chatMessages.reversed.toList(),
      //     status: ChatRoomStates.initState));
    } else {
      debugPrint("Error chat id not found");
    }
  }

  typingMessage() {
    _socketService.typingMessage(chatId: chatId!);
  }

  Future<void> getUser() async {
    final result = await _getUserUseCase(const NoParams());
    result.fold(
      (failure) {
        userId = '';
      },
      (user) {
        userId = user.id;
      },
    );
  }

  listenToNewMessages() {
    _socketService.socketMessageStream.listen((event) {
      chatMessages.add(event);
      emit.call(state.copyWith(
          chatData: chatMessagesModel,
          chatMessages: chatMessages,
          status: ChatRoomStates.initState));


      Timer(
          const Duration(milliseconds: 200),
              () => scrollController!
              .jumpTo(scrollController!.position.maxScrollExtent));

    });


  }

  listenToMessageTyping() {
    _socketService.socketChatTypingStream.listen((event) {
      debugPrint("chatListen ${event}");

      List<TypingAndOnlineModel> chatsIds = event ?? [];
      chatsIds.map((e) {}).toList();

      emit.call(state.copyWith(
          chatData: chatMessagesModel,
          chatMessages: chatMessages,
          status: ChatRoomStates.typing));
    });
  }

  deleteMessage({required String chatId, required String messageId}) async {
    DeleteMessageParams deleteMessageParams =
        DeleteMessageParams(chatId: chatId, messageId: messageId);
    await _deleteChatMessageUseCase.call(deleteMessageParams);
    getChatMessages(chatId);
  }

  @override
  Future<void> close() {
    // _socketService.disposeSocket();
    return super.close();
  }
}
