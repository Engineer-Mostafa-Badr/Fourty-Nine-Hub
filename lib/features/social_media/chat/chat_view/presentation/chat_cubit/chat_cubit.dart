import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/chats_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getChats_usecase.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final GetTokensUseCase _getTokensUseCase;
  final GetChatsUseCase _getChatsUseCase;
  String? userToken;
  late Socket socket;
  final messageTextController = TextEditingController();

  ChatsCubit(
    this._getTokensUseCase,
    this._getChatsUseCase,
  ) : super(const ChatsState());

  initSocketConnection() async {
    try {
      String? userToken = await getUserToken();

      debugPrint("Toke=> ${userToken}");

      socket = io(
          'https://49dev.com',
          OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
               // disable auto-connection
              .setExtraHeaders(
                  {'foo': 'bar', 'authorization': '$userToken'}) // optional
              .build());

      socket.connect();

      socket.onConnect((_) {
        debugPrint('Connect to Socket successfully');
        // socket.emit('msg', 'test');
      });

      // socket.one;
      socket.on('event', (data) => debugPrint(data));
      socket.on('message', (data) {
        print("Delivered ${data}");
        final dataList = data as List;
        final ack = dataList.last as Function;
        ack(null);
      });

      socket.on('user:message', (data) {
        print("Delivered ${data}");
        final dataList = data as List;
        final ack = dataList.last as Function;
        ack(null);
      });

      socket.on('Message:Send', (data) {
        print("Delivered ${data}");
        final dataList = data as List;
        final ack = dataList.last as Function;
        ack(null);
      });

      socket.on('Send', (data) {
        print("Delivered ${data}");
        final dataList = data as List;
        final ack = dataList.last as Function;
        ack(null);
      });

      socket.on('Delivered', (data) {
        print("Delivered ${data}");
        final dataList = data as List;
        final ack = dataList.last as Function;
        ack(null);
      });

      socket.on('Message:Delivered', (data) {
        print("Delivered ${data}");
        final dataList = data as List;
        final ack = dataList.last as Function;
        ack(null);
      });
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

  getChats() async {
    final response = await _getChatsUseCase.call(ChatsRequestParams(privacyId: 'normal', categoryId: '668e7dc4e8cfec5bcc752afc'));
    response.fold(
        (failure) => emit.call(
            state.copyWith(failure: failure, status: ChatsStates.error)),
        (data) {
          return emit.call(state.copyWith(
              chats: data, status: ChatsStates.initState));
        });

  }

  @override
  Future<void> close() {
    socket.disconnect();
    socket.dispose();
    return super.close();
  }
}
