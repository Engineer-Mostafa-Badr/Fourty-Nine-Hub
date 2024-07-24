import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract class SocketServiceContract {
  Socket get socket;

  initSocketConnection(String userToken);

  sendMessage({required String message, required String chatId});
}

class SocketServiceImplementation extends SocketServiceContract {
  @override
  late Socket socket;

  @override
  initSocketConnection(userToken) async {
    try {
      debugPrint("Toke=> ${userToken}");

      socket = io(
          'https://49dev.com',
          OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
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

  @override
  sendMessage({required String message, required String chatId}) {
    if (message.isEmpty) return;
    Map messageMap = {
      "chatId": chatId,
      "type": 1,
      "mediaIds": [],
      "text": "Welcome 12",
      "groupId": null
    };
    socket.emit('Message:Send', messageMap);
  }
}
