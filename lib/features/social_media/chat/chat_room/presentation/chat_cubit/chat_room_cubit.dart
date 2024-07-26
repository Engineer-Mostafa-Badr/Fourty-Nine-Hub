import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/service/socket_service.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_user_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/message_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/getChatMessages_usecase.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'chat_view_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final GetTokensUseCase _getTokensUseCase;
  final GetChatMessagesUseCase _getChatMessagesUseCase;
  final GetUserUseCase _getUserUseCase;
  final SocketServiceContract _socketService;
  List<MessageEntity> chatMessages = [];

  String? userToken;
  String? userId;
  String? chatId;
  ChatRoomCubit(
    this._getTokensUseCase,
    this._getChatMessagesUseCase,
    this._getUserUseCase,
    this._socketService,
  ) : super(const ChatRoomState());

  Future<String?> getUserToken() async {
    return _getTokensUseCase(const NoParams()).then((value) {
      return value.fold((l) => null, (r) => r?.accessToken);
    });
  }

  getChatMessages(String chatID) async {
    chatId = chatID;
    final response = await _getChatMessagesUseCase.call(chatID);
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: ChatRoomStates.error)),
        (data) {
          chatMessages = data;
          emit(state.copyWith(
              chatMessages: data.reversed.toList(), status: ChatRoomStates.initState));
        });

    // to listen new message
    listenToNewMessages();
  }

  sendMessage(String message) {
    if(chatId != null){

      _socketService.sendMessage(
          message: message, chatId: chatId!);
      chatMessages.add(MessageModel(text: message,byMe: true));

      emit
          .call(state.copyWith(chatMessages: chatMessages.reversed.toList(), status: ChatRoomStates.initState));
    }else{
      debugPrint("Error chat id not found");
    }
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
      chatMessages.add(MessageModel(text: event.messageItem?.text,byMe: false));
      emit
          .call(state.copyWith(chatMessages: chatMessages.reversed.toList(), status: ChatRoomStates.initState));
    });
  }

  @override
  Future<void> close() {
    // socket.disconnect();
    // socket.dispose();
    return super.close();
  }
}
