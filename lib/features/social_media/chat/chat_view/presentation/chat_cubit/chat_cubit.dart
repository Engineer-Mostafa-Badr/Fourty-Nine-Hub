import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/service/socket_service.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatMuteState_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/chats_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getChats_usecase.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final GetTokensUseCase _getTokensUseCase;
  final GetChatsUseCase _getChatsUseCase;
  final ChangeChatMuteStateUseCase _changeChatMuteStateUseCase;
  final SocketServiceContract _socketService;
  String? userToken;
  late Socket socket;
  final messageTextController = TextEditingController();
  final Map<String, ChatItemModel> _chats = {};

  ChatsCubit(
    this._getTokensUseCase,
    this._getChatsUseCase,
    this._socketService,
    this._changeChatMuteStateUseCase,
  ) : super(const ChatsState());

  initSocketConnection() async {
    String? userToken = await getUserToken();
    _socketService.initSocketConnection(userToken!);

    // listen to new messages
    listenToNewMessages();
  }

  Future<String?> getUserToken() async {
    return _getTokensUseCase(const NoParams()).then((value) {
      return value.fold((l) => null, (r) => r?.accessToken);
    });
  }

  getChats(int index) async {
    ChatsRequestParams chatsRequestParams = getTabParams(index);
    if (chatsRequestParams.categoryId == null) {
      return emit
          .call(state.copyWith(chats: [], status: ChatsStates.initState));
    } else {
      final response = await _getChatsUseCase.call(
        chatsRequestParams,
      );
      response.fold(
          (failure) => emit.call(
              state.copyWith(failure: failure, status: ChatsStates.error)),
          (data) {
        data
            .map((e) => _chats.update(e.sId!, (value) => e, ifAbsent: () => e))
            .toList();
        return emit
            .call(state.copyWith(chats: data, status: ChatsStates.initState));
      });
    }
  }

  listenToNewMessages() {
    _socketService.socketMessageStream.listen((event) {
      _chats[event.chatRoomId]?.lastMessageText = event.messageItem?.text;
      emit.call(state.copyWith(
          chats: _chats.values.toList(), status: ChatsStates.initState));
    });
  }

  changeChatMuteState(String chatId) async {
    final response = await _changeChatMuteStateUseCase.call(chatId);
    response.fold(
        (failure) => emit
            .call(state.copyWith(failure: failure, status: ChatsStates.error)),
        (data) {
      _chats[chatId]?.muted = !_chats[chatId]!.muted!;
      return emit.call(state.copyWith(
          chats: _chats.values.toList(), status: ChatsStates.initState));
    });
  }

  ChatsRequestParams getTabParams(int index) {
    if (index == 0) {
      return ChatsRequestParams(
        privacyId: 'normal',
        categoryId: '668e7dc4e8cfec5bcc752afc',
        isLocked: false,
        archived: false,
      );
    } else {
      return ChatsRequestParams();
    }
  }

  @override
  Future<void> close() {
    socket.disconnect();
    socket.dispose();
    return super.close();
  }
}
