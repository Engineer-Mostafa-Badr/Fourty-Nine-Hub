import 'dart:developer';

import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SharedWebSocket {
  static IO.Socket? socket;
  static const String _url = 'https://49dev.com';

  static bool _isConnecting = false;

  static void connect({required String token}) async {
    if (_isConnecting || (socket != null && socket!.connected)) {
      log("Socket is already connecting or connected, skipping...");
      return;
    }

    _isConnecting = true;

    if (token == await CacheManager.getAccessToken()) {
      log("Token from connect socket matches cached token: $token");
    }

    log("Socket connect start connection...");
    log("Token from connect socket befor connection: $token");
    socket = IO.io(
      _url,
      {
        'transports': ['websocket'],
        'autoConnect': true,
        'extraHeaders': {'Authorization': token},
      },
    );
    socket!.connect();

    socket!.onConnect((data) {
      log("Socket on connect called");
      log("Token from connect socket: $token");
      log("Socket connect called, connected: ${socket?.connected}");
      log("Socket connect called, ID: ${socket?.id}");
      _isConnecting = false;
    });

    socket!.onError((error) {
      log("Socket connection error: $error");
      _isConnecting = false;
    });
  }

  static void disconnect() {
    if (socket != null) {
      log("Socket disconnect process started...");
      _isConnecting = false; 
      log("Disconnecting socket...");
      socket!.disconnect(); 

      log("Removing all socket listeners...");
      socket!
          .clearListeners(); 

      log("Nullifying the socket instance...");
      socket = null; 

      log("Socket disconnected successfully.");
    } else {
      log("Socket disconnect called, but no active socket to disconnect.");
    }
  }
}
