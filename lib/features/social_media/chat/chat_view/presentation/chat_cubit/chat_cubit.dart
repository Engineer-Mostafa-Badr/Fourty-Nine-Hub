import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/service/socket_service.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/typing_and_online_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatMuteState_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatToArchiveNormal_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/chats_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getChats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/lock_chat_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/lock_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/unlock_chat_usecase.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final SocketServiceContract _socketService;
  final GetTokensUseCase _getTokensUseCase;
  final GetChatsUseCase _getChatsUseCase;
  final ChangeChatMuteStateUseCase _changeChatMuteStateUseCase;
  final ChangeChatToArchiveOrNormalUseCase _changeChatToArchiveOrNormalUseCase;
  final LockChatUseCase _lockChatUseCase;
  final UnLockChatUseCase _unLockChatUseCase;

  String? userToken;
  late int selectedTabIndex;
  late String lockChatPassword;
  final messageTextController = TextEditingController();
  final Map<String, ChatItemModel> _chats = {};

  ChatsCubit(
    this._getTokensUseCase,
    this._getChatsUseCase,
    this._socketService,
    this._changeChatMuteStateUseCase,
    this._changeChatToArchiveOrNormalUseCase,
    this._lockChatUseCase,
    this._unLockChatUseCase,
  ) : super(const ChatsState());

  initSocketConnection() async {
    String? userToken = await getUserToken();
    _socketService.initSocketConnection(userToken!);

    // listen to new messages
    listenToNewMessages();
    listenToMessageTyping();
  }

  _joinRoom(String chatId) async {
    _socketService.joinRoom(chatId);
  }

  Future<String?> getUserToken() async {
    return _getTokensUseCase(const NoParams()).then((value) {
      return value.fold((l) => null, (r) => r?.accessToken);
    });
  }

  getChats({required int index, String? password}) async {
    selectedTabIndex = index;

    // if this locked chat tab & password null return empty list
    if (index == 8 && password == null) {
      return emit
          .call(state.copyWith(chats: [], status: ChatsStates.initState));
    }
    ChatsRequestParams chatsRequestParams =
        getTabParams(index: index, password: password);
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
          (data) async {
        data
            .map((e) => _chats.update(e.sId!, (value) => e, ifAbsent: () => e))
            .toList();

        // to can listen or start chat , should to join room id
        // data.map((e) => _joinRoom(e.sId!).toList());
        // _joinRoom(data[0].sId!);

        // to listen typing and online emit event status
        List<UserStatusParams> userStatusParams = [];
        for (var item in _chats.values) {
          userStatusParams
              .add(UserStatusParams(chatId: item.sId!, userId: item.userId!));
        }

        await Future.delayed(Duration(seconds: 1));
        sendUserStatus(userStatusParams);

        _socketService.listenToUserStatus();

        return emit
            .call(state.copyWith(chats: data, status: ChatsStates.initState));
      });
    }
  }

  listenToNewMessages() {
    _socketService.socketMessageStream.listen((event) {
      debugPrint("Last message chat cubit ${event.text}");
      _chats[event.chatId]?.lastMessageText = event.text;
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
      getChats(index: selectedTabIndex);
      return;
    });
  }

  ChatsRequestParams getTabParams({required int index, String? password}) {
    // 0 => Normal
    // 7 => Archived
    // 8 => Locked
    // 9 => unRead

    if (index == 0) {
      return ChatsRequestParams(
        privacyId: 'normal',
        categoryId: UIConst.chatNormalId,
        isLocked: false,
        isUnread: false,
        archived: false,
      );
    } else if (index == 7) {
      return ChatsRequestParams(
        privacyId: 'normal',
        categoryId: UIConst.chatNormalId,
        isLocked: false,
        isUnread: false,
        archived: true,
      );
    } else if (index == 8) {
      return ChatsRequestParams(
          privacyId: 'normal',
          categoryId: UIConst.chatNormalId,
          isLocked: true,
          archived: false,
          isUnread: false,
          lockChatPassword: password);
    } else if (index == 9) {
      return ChatsRequestParams(
          privacyId: 'normal',
          categoryId: UIConst.chatNormalId,
          isLocked: false,
          archived: false,
          isUnread: true,
          lockChatPassword: password);
    } else {
      return ChatsRequestParams();
    }
  }

  Future<bool> lockChat(
      {required String chatId, String? lockChatPassword}) async {
    bool result = true;
    LockChatParams lockChatParams =
        LockChatParams(chatId: chatId, lockChatPassword: lockChatPassword);
    final response = await _lockChatUseCase.call(lockChatParams);
    response.fold((failure) {
      ServerFailure failureBackend = failure as ServerFailure;
      if (failureBackend.errors != null) {
        if (failureBackend.errors!.contains('password is required')) {
          result = false;
        } else {
          result = true;
        }
      } else {
        result = true;
      }
    }, (data) {
      getChats(index: selectedTabIndex);
      result = true;
    });
    return result;
  }

  unLockChat({required String chatId, String? lockChatPassword}) async {
    LockChatParams lockChatParams =
        LockChatParams(chatId: chatId, lockChatPassword: lockChatPassword);
    final response = await _unLockChatUseCase.call(lockChatParams);
    response.fold(
        (failure) => emit
            .call(state.copyWith(failure: failure, status: ChatsStates.error)),
        (data) {
      getChats(index: selectedTabIndex, password: lockChatPassword);
    });
  }

  listenToMessageTyping() {
    _socketService.socketChatTypingStream.listen((event) {
      List<TypingAndOnlineModel> chatsIds = event ?? [];

      for (var key in chatsIds) {
        // print("event22 ${key.chatId}");
        _chats[key.chatId]!.typing = key.typing;
        _chats[key.chatId]!.online = key.online;
      }

      emit.call(state.copyWith(
          chats: _chats.values.toList(), status: ChatsStates.typing));
    });
  }

  sendUserStatus(List<UserStatusParams> params) {
    Timer? timer;
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      _socketService.sendUserStatus(params);
    });
  }

  @override
  Future<void> close() {
    print("Close Socket");
    _socketService.disposeSocket();
    return super.close();
  }
}
