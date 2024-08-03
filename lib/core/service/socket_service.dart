import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/socket_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract class SocketServiceContract {
  Socket get socket;

  initSocketConnection(String userToken);

  joinRoom(String chatId);

  getRoomUsersJoined();

  sendMessage({required String message, required String chatId});


  sendUserStatus(List<UserStatusParams> params);
  listenToUserStatus();

  typingMessage({required String chatId});

  // listen to new message
  Stream<SocketMessageModel> get socketMessageStream;

  Stream<List<String>?> get socketChatTypingStream;

  disposeSocket();

}

class SocketServiceImplementation extends SocketServiceContract {
  @override
  late Socket socket;

  final BehaviorSubject<SocketMessageModel> _socketMessageStream =
      BehaviorSubject<SocketMessageModel>();

  final BehaviorSubject<List<String>> _socketChatTyping =
      BehaviorSubject<List<String>>();

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
        debugPrint('\nConnect To Socket successfully ');

        // getRoomUsersJoined();

        // joinRoom('yy');
        // to receive new messages
        socket.on('user:message', (data) {
          debugPrint("user:message ${data}");
          final dataList = data as List;

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

        // listen to messages that sent from current user
        socket.on('messageSent', (data) {
          debugPrint("messageSent ${data}");
          final dataList = data as List;

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





        // socket.on('messageTyping', (data) {
        //   // debugPrint("data ${data}");
        //   var dataList = json.decode(data);
        //   debugPrint("messageTyping ${dataList}");
        //   List<String> chatIdsTyping = dataList as List<String>;
        //   debugPrint("chatIdsTyping ${chatIdsTyping}");
        //   _socketChatTyping.add(chatIdsTyping);
        // });
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
  Stream<List<String>> get socketChatTypingStream => _socketChatTyping.stream;

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
    socket.dispose();
  }

  @override
  sendUserStatus(List<UserStatusParams> params) {
    Map<String ,dynamic> paramaters = {};
    List<Map<String ,dynamic>> ids = [];

    for(int i = 0; i < params.length; i++){
      paramaters['_id'] =  params[i].chatId;
      paramaters['userId'] =  params[i].userId;
      ids.add(paramaters);
    }


    print("paramaters ${ids}");



    var messageMap = json.encode(ids);

    socket.emit('Chat:getRooms', messageMap);
  }

  @override
  listenToUserStatus() {
    socket.on('usersStatus', (data) {
      debugPrint("usersStatus ${data}");
      var dataList = json.decode(data);
      debugPrint("usersStatus ${dataList}");
      List<String> chatIdsTyping = dataList as List<String>;
      debugPrint("chatIdsTyping ${chatIdsTyping}");
      _socketChatTyping.add(chatIdsTyping);
    });

  }
}


class UserStatusParams {
  String chatId;
  String userId;
  UserStatusParams({required this.chatId,required this.userId});
}
