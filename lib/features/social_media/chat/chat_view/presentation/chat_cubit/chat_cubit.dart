import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/data/datasources/remote/socket/socket_data_source.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/seen_history_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/typing_and_online_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatMuteState_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/changeChatToArchiveNormal_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/chats_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getChats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getGroupsChats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/getSeenHistoryUseCase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/lock_chat_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/lock_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/unlock_chat_usecase.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ChatSocketServiceContract _socketService;
  final GetTokensUseCase _getTokensUseCase;
  final GetChatsUseCase _getChatsUseCase;
  final ChangeChatMuteStateUseCase _changeChatMuteStateUseCase;
  final ChangeChatToArchiveOrNormalUseCase _changeChatToArchiveOrNormalUseCase;
  final LockChatUseCase _lockChatUseCase;
  final UnLockChatUseCase _unLockChatUseCase;
  final GroupsChatsUseCase _groupsChatsUseCase;
  final GetSeenHistoryUseCase _getSeenHistoryUseCase;
  int unReadMessage = 0;

  String? userToken;
  late int selectedTabIndex;
  late String lockChatPassword;
  final messageTextController = TextEditingController();
  final Map<String, ChatModel> _chats = {};
  List<UserStatusParams> userStatusParams = [];
  List<SeenHistoryModel> seenHistoryList = [];

  ChatsCubit(
    this._getTokensUseCase,
    this._getChatsUseCase,
    this._socketService,
    this._changeChatMuteStateUseCase,
    this._changeChatToArchiveOrNormalUseCase,
    this._lockChatUseCase,
    this._unLockChatUseCase,
    this._groupsChatsUseCase,
    this._getSeenHistoryUseCase,
  ) : super(const ChatsState());

  initSocketConnection() async {
    String? userToken = await getUserToken();
    _socketService.initSocketConnection(userToken!);
    SocketIODataSource.instance.connect();
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

  initChat() async {
    await getChats(index: 0);
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

    if (chatsRequestParams.categoryId == null && index != 5) {
      return emit
          .call(state.copyWith(chats: [], status: ChatsStates.initState));
    } else {
      _chats.clear();
      var response;
      if (index == 5) {
        response = await _groupsChatsUseCase.call(const NoParams());
      } else {
        response = await _getChatsUseCase.call(
          chatsRequestParams,
        );
      }

      response.fold(
          (failure) => emit.call(
              state.copyWith(failure: failure, status: ChatsStates.error)),
          (data) async {
        data.chats!
            .map((e) => _chats.update(e.sId!, (value) => e, ifAbsent: () => e))
            .toList();

        // to listen typing and online emit event status
        List<UserStatusParams> userStatusParams = [];
        for (var item in _chats.values) {
          userStatusParams
              .add(UserStatusParams(chatId: item.sId!, userId: item.userId!));
        }

        await Future.delayed(const Duration(seconds: 1));
        sendUserStatus(userStatusParams);
        _socketService.listenToUserStatus();
        unReadMessage = data.totalUnread ?? 0;

        return emit.call(
            state.copyWith(chats: data.chats, status: ChatsStates.initState));
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

  //   listenToNewMessages() {
  //   _socketService.socketMessageStream.listen((event) {
  //     if (!_chats.values.isEmpty) {
  //       _chats[event.chatId]?.lastMessageText = event.text;
  //       emit.call(state.copyWith(
  //           chats: _chats.values.toList(), status: ChatsStates.initState));
  //     }
  //   });
  // }

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
    // 1 => Services
    // 4 => Greets
    // 5 => Groups
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
        isServices: false,
      );
    } else if (index == 1) {
      return ChatsRequestParams(
        privacyId: 'normal',
        categoryId: UIConst.chatNormalId,
        isLocked: false,
        isUnread: false,
        archived: false,
        isServices: true,
      );
    } else if (index == 4) {
      return ChatsRequestParams(
        privacyId: 'normal',
        categoryId: UIConst.chatGreetId,
        isLocked: false,
        isUnread: false,
        archived: false,
        isServices: false,
      );
    } else if (index == 7) {
      return ChatsRequestParams(
        privacyId: 'normal',
        categoryId: UIConst.chatNormalId,
        isLocked: false,
        isUnread: false,
        archived: true,
        isServices: false,
      );
    } else if (index == 8) {
      return ChatsRequestParams(
          privacyId: 'normal',
          categoryId: UIConst.chatNormalId,
          isLocked: true,
          archived: false,
          isUnread: false,
          isServices: false,
          lockChatPassword: password);
    } else if (index == 9) {
      return ChatsRequestParams(
          privacyId: 'normal',
          categoryId: UIConst.chatNormalId,
          isLocked: false,
          archived: false,
          isServices: false,
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

      if (_chats.values.length > 0) {
        for (var key in chatsIds) {
          _chats[key.chatId]?.typing = key.typing;
          _chats[key.chatId]?.online = key.online;
        }

        emit.call(state.copyWith(
            chats: _chats.values.toList(), status: ChatsStates.typing));
      }
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
    // print("Close Socket");
    _socketService.disposeSocket();
    SocketIODataSource.instance.close();
    return super.close();
  }

  getSeenHistory(String chatId, BuildContext context) async {
    var response;
    response = await _getSeenHistoryUseCase.call(chatId);
    response.fold(
      (failure) => emit
          .call(state.copyWith(failure: failure, status: ChatsStates.error)),
      (data) async {
        seenHistoryList = data;

        // emit(data);
        showDialogToSeenHistory(context);
      },
    );
  }

  Future<bool?> showDialogToSeenHistory(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            title: Label(
                text: 'Seen History',
                style: Styles.headerText(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            content: Container(
                height: 300.h,
                width: 400,
                child: Column(
                  children: [
                    Label(
                      text: seenHistoryList[0].name ?? "",
                      style:  TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.w700),
                    ),
                    Flexible(
                      flex: 1,
                      child: ListView.builder(
                        itemCount: seenHistoryList.length,
                        padding:  EdgeInsets.symmetric(vertical: 8.h),
                        itemBuilder: (context, index) {
                          return Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(4),
                              color: Colors.grey[300],
                              child: Row(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Icon(
                                      FontAwesomeIcons.eye,
                                      color: Colors.blueAccent,
                                      size: 14,
                                    ),
                                  ),
                                  Label(
                                      text:
                                          "${seenHistoryList[index].date}  ${seenHistoryList[index].time}")
                                ],
                              ));
                        },
                      ),
                    ),
                  ],
                )),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Close')),
            ],
          )),
    );
  }
}
