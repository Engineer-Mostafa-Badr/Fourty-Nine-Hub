import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/service/socket_service.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatMuteState_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatToArchiveNormal_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/chats_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getChats_usecase.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final GetTokensUseCase _getTokensUseCase;
  final GetChatsUseCase _getChatsUseCase;
  final ChangeChatMuteStateUseCase _changeChatMuteStateUseCase;
  final ChangeChatToArchiveOrNormalUseCase _changeChatToArchiveOrNormalUseCase;
  final SocketServiceContract _socketService;
  String? userToken;
  late Socket socket;
  late int selectedTabIndex;
  final messageTextController = TextEditingController();
  final Map<String, ChatItemModel> _chats = {};

  ChatsCubit(
    this._getTokensUseCase,
    this._getChatsUseCase,
    this._socketService,
    this._changeChatMuteStateUseCase,
    this._changeChatToArchiveOrNormalUseCase,
  ) : super(const ChatsState());

  initSocketConnection() async {
    String? userToken = await getUserToken();
    _socketService.initSocketConnection(userToken!);

    // listen to new messages
    listenToNewMessages();
  }

  joinRoom(String chatId) async {
    _socketService.joinRoom(chatId);
  }

  Future<String?> getUserToken() async {
    return _getTokensUseCase(const NoParams()).then((value) {
      return value.fold((l) => null, (r) => r?.accessToken);
    });
  }

  getChats(int index) async {
    selectedTabIndex = index;
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

        // to can listen or start chat , should to join room id
        if (data.isNotEmpty) {
          joinRoom(data[0].sId!);
        }

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

  changeChatToArchiveOrNormalUseCase(String chatId) async {
    final response = await _changeChatToArchiveOrNormalUseCase.call(chatId);
    response.fold(
        (failure) => emit
            .call(state.copyWith(failure: failure, status: ChatsStates.error)),
        (data) {
      getChats(selectedTabIndex);
      return;
    });
  }

  ChatsRequestParams getTabParams(int index) {
    if (index == 0) {
      return ChatsRequestParams(
        privacyId: 'normal',
        categoryId: UIConst.chatNormalId,
        isLocked: false,
        archived: false,
      );
    } else if (index == 7) {
      return ChatsRequestParams(
        privacyId: 'normal',
        categoryId: UIConst.chatNormalId,
        isLocked: false,
        archived: true,
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
