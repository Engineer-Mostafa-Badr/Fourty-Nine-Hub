import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SharedWebSocket {
  IO.Socket? socket;
  final String _url = 'https://49dev.com';

  SharedWebSocket._privateConstructor();

  static SharedWebSocket? _instance;

  static SharedWebSocket get instance {
    _instance ??= SharedWebSocket._privateConstructor();
    return _instance!;
  }

  void connect({required String token}) {
    if (socket == null || !(socket!.connected)) {
      log("token from connct socket $token");
      socket = IO.io(
          _url,
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setExtraHeaders({'Authorization': token}) // optional
              .build());
      socket!.connect();
    }
  }

  void disconnect() {
    socket?.disconnect();
    log("socket disconnect called");
    socket = null;
  }
}
