import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/domain/usecases/getChatMessages_usecase.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatMessageState> {
  final GetTokensUseCase _getTokensUseCase;
  final GetChatMessagesUseCase _getChatMessagesUseCase;
  String? userToken;
  late Socket socket;
  final messageTextController = TextEditingController();

  ChatCubit(
    this._getTokensUseCase,
    this._getChatMessagesUseCase,
  ) : super(const ChatMessageState());

  initSocketConnection() async {
    try {
      String? userToken = await getUserToken();

      socket = io(
          'https://49dev.com',
          OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .disableAutoConnect() // disable auto-connection
              .setExtraHeaders(
                  {'foo': 'bar', 'authorization': '$userToken'}) // optional
              .build());

      socket.connect();

      socket.onConnect((_) {
        debugPrint('Connect to Socket successfully');
        // socket.emit('msg', 'test');
      });

      socket.on('event', (data) => debugPrint(data));
      socket.onDisconnect((_) => debugPrint('disconnect'));
      socket.onerror((e) => debugPrint('onError $e'));
      socket.on(
          'fromServer', (_) => debugPrint("Connect from server successfully"));
    } catch (e) {
      debugPrint('Connection established$e');
    }
  }

  Future<String?> getUserToken() async {
    return _getTokensUseCase(const NoParams()).then((value) {
      return value.fold((l) => null, (r) => r?.accessToken);
    });
  }

  getChatMessages() async {
    final response = await _getChatMessagesUseCase.call("userId");
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: ChatMessagesStates.error)),
        (data) => emit(state.copyWith(
            chatMessages: data, status: ChatMessagesStates.initState)));
  }

  sendMessage() {
    String message = messageTextController.text.trim();
    if (message.isEmpty) return;
    Map messageMap = {
      'message': message,
      'senderId': 'userId',
      'receiverId': 'receiverId',
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    socket.emit('sendNewMessage', messageMap);
  }

  @override
  Future<void> close() {
    socket.disconnect();
    socket.dispose();
    return super.close();
  }
}
