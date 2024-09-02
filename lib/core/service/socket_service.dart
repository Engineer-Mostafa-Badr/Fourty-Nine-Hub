import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/message_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/typing_and_online_model.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract class ChatSocketServiceContract {
  Socket get socket;

  initSocketConnection(String userToken);

  joinRoom(String chatId);

  getRoomUsersJoined();

  sendMessage({
    required String message,
    required String chatId,
    String? replyMessageId,
  });

  sendUserStatus(List<UserStatusParams> params);

  listenToUserStatus();

  typingMessage({required String chatId});

  // listen to new message
  Stream<MessageModel> get socketMessageStream;

  Stream<List<TypingAndOnlineModel>?> get socketChatTypingStream;

  disposeSocket();
}

class ChatSocketServiceImplementation extends ChatSocketServiceContract {
  @override
  late Socket socket;

  final BehaviorSubject<MessageModel> _socketMessageStream =
      BehaviorSubject<MessageModel>();

  final BehaviorSubject<List<TypingAndOnlineModel>> _socketChatTyping =
      BehaviorSubject<List<TypingAndOnlineModel>>();

  @override
  initSocketConnection(userToken) async {
    try {
      socket = io(
          'https://49dev.com',
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setExtraHeaders({'authorization': userToken}) // optional
              .build());

      socket.connect();

      socket.onConnect((_) {
        CliLogger.success('\nConnect To Socket successfully ');

        // getRoomUsersJoined();

        // joinRoom('yy');
        // to receive new messages
        socket.on('user:message', (data) {
          debugPrint("user:message $data");

          MessageModel messageModel = MessageModel.fromJson(data);

          _socketMessageStream.add(messageModel);
          CliLogger.info("socketMessageModel ${messageModel.text}");
        });

        // listen to messages that sent from current user
        socket.on('messageSent', (data) {
          CliLogger.info("messageSent $data");

          MessageModel messageModel = MessageModel.fromJson(jsonDecode(data));

          _socketMessageStream.add(messageModel);

          CliLogger.info("socketMessageModel ${messageModel.text}");
        });
      });

      socket.on('error', (data) {
        CliLogger.error("error $data");
      });

      socket.onDisconnect((_) => CliLogger.info('socket disconnect'));
      socket.onerror((e) => CliLogger.error('onError $e'));
    } catch (e) {
      debugPrint('Connection established$e');
    }
  }

  @override
  sendMessage({
    required String message,
    required String chatId,
    String? replyMessageId,
  }) {
    if (message.isEmpty) return;

    var messageMap = json.encode({
      "chatId": chatId,
      "type": 1,
      "mediaIds": [],
      "text": message,
      "groupId": null,
      if (replyMessageId != null) "replyMessageId": replyMessageId
    });
    socket.emit('Message:Send', messageMap);
  }

  @override
  Stream<MessageModel> get socketMessageStream => _socketMessageStream.stream;

  @override
  joinRoom(String chatId) {
    var jsonString = json.encode({"chatId": chatId});
    socket.emit("Chat:joinRoom", jsonString);

    // socket.on('getRooms', (data) {
    //   debugPrint("data ${data}");
    // });
  }

  @override
  typingMessage({required String chatId}) {
    if (chatId.isEmpty) return;

    var messageMap = json.encode({
      "chatId": chatId,
    });
    socket.emit('Message:Typing', messageMap);

    debugPrint("Emit");
  }

  @override
  Stream<List<TypingAndOnlineModel>> get socketChatTypingStream =>
      _socketChatTyping.stream;

  @override
  getRoomUsersJoined() {
    var messageMap = json.encode({
      "privacy": "normal",
      "categoryId": "668e7dc4e8cfec5bcc752afc",
      "archived": false,
      "isLocked": false,
      "password": 123,
      "isUnread": false
    });

    socket.emit('Chat:getRooms', messageMap);
  }

  @override
  disposeSocket() {
    socket.disconnect();
    _socketChatTyping.close();
    _socketMessageStream.close();
    socket.dispose();
  }

  @override
  sendUserStatus(List<UserStatusParams> params) {
    Map<String, dynamic> paramaters = {};
    List<Map<String, dynamic>> ids = [];

    for (int i = 0; i < params.length; i++) {
      paramaters['_id'] = params[i].chatId;
      paramaters['userId'] = params[i].userId;
      ids.add(paramaters);
    }

    var messageMap = json.encode(ids);

    socket.emit('Chat:usersStatus', messageMap);
  }

  @override
  listenToUserStatus() {
    // socket.on('usersStatus', (data) {
    //   List<TypingAndOnlineModel> chatIdsTyping = [];
    //   debugPrint("usersStatus $data");

    //   chatIdsTyping.addAll(List<TypingAndOnlineModel>.from(
    //       json.decode(data).map((x) => TypingAndOnlineModel.fromJson(x))));

    //   _socketChatTyping.add(chatIdsTyping);
    // });
  }
}

class UserStatusParams {
  String chatId;
  String userId;

  UserStatusParams({required this.chatId, required this.userId});
}
