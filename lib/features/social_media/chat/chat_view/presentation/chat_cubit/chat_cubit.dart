import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/service/socket_service.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/chats_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getChats_usecase.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final GetTokensUseCase _getTokensUseCase;
  final GetChatsUseCase _getChatsUseCase;
  final SocketServiceContract _socketService;
  String? userToken;
  late Socket socket;
  final messageTextController = TextEditingController();

  ChatsCubit(
    this._getTokensUseCase,
    this._getChatsUseCase,
    this._socketService,
  ) : super(const ChatsState());

  initSocketConnection() async {
    String? userToken = await getUserToken();
    _socketService.initSocketConnection(userToken!);
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
