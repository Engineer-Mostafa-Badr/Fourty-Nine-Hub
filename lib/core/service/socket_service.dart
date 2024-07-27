import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/socket_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract class SocketServiceContract {
  Socket get socket;

  initSocketConnection(String userToken);

  joinRoom(String chatId);

  sendMessage({required String message, required String chatId});

  // listen to new message
  Stream<SocketMessageModel> get socketMessageStream;
}

class SocketServiceImplementation extends SocketServiceContract {
  @override
  late Socket socket;

  final BehaviorSubject<SocketMessageModel> _socketMessageStream =
      BehaviorSubject<SocketMessageModel>();

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
        // to receive new messages
        socket.on('user:message', (data) {
          debugPrint("Delivered ${data}");
          final dataList = data as List;
          debugPrint("dataList ${dataList[0]}");

          SocketMessageModel socketMessageModel =
              SocketMessageModel.fromJson(dataList[0]);

          try {
            _socketMessageStream.add(socketMessageModel);
            debugPrint(
                "socketMessageModel ${socketMessageModel.messageItem?.text}");
          } catch (e) {
            debugPrint("socketMessageModelerrrrrrrroooooe ${e}");
          }
          debugPrint(
              "socketMessageModel ${socketMessageModel.messageItem?.text}");
        });

        socket.on('messageTyping', (data) {
          debugPrint("Delivered ${data}");
          final dataList = data as List;
          debugPrint("dataList ${dataList[0]}");

          SocketMessageModel socketMessageModel =
              SocketMessageModel.fromJson(dataList[0]);

          debugPrint(
              "socketMessageModel ${socketMessageModel.messageItem?.text}");
        });
      });

      socket.on('error', (data) {
        debugPrint("error ${data}");
        debugPrint(data);
      });

      socket.onDisconnect((_) => debugPrint('disconnect'));
      socket.onerror((e) => debugPrint('onError $e'));
    } catch (e) {
      debugPrint('Connection established$e');
    }
  }

  @override
  sendMessage({required String message, required String chatId}) {
    if (message.isEmpty) return;

    var messageMap = json.encode({
      "chatId": chatId,
      "type": 1,
      "mediaIds": [],
      "text": message,
      "groupId": null
    });
    socket.emit('Message:Send', messageMap);
  }

  @override
  Stream<SocketMessageModel> get socketMessageStream =>
      _socketMessageStream.stream;

  @override
  joinRoom(String chatId) {
    debugPrint('Connect to Socket successfully');
    var jsonString = json.encode({"chatId": chatId});

    socket.emit("Chat:joinRoom", jsonString);
  }
}
