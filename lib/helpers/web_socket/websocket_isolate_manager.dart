import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum WebSocketMessageType {
  connect,
  disconnect,
  emit,
  subscribe,
  unsubscribe,
  socketEvent
}

class WebSocketIsolateMessage {
  final WebSocketMessageType type;
  final Map<String, dynamic> data;

  WebSocketIsolateMessage(this.type, this.data);

  Map<String, dynamic> toJson() => {
    'type': type.index,
    'data': data,
  };

  factory WebSocketIsolateMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketIsolateMessage(
      WebSocketMessageType.values[json['type']],
      json['data'],
    );
  }
}

class WebSocketIsolateManager {
  static WebSocketIsolateManager? _instance;
  static WebSocketIsolateManager get instance =>
      _instance ??= WebSocketIsolateManager._();

  WebSocketIsolateManager._();

  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;
  final Map<String, List<Function(dynamic)>> _eventHandlers = {};
  Completer<void>? _connectionCompleter;

  Future<void> initialize() async {
    if (_isolate != null) return;

    try {
      _receivePort = ReceivePort();

      // Create a completer to get the first message (SendPort)
      final sendPortCompleter = Completer<SendPort>();

      // Set up listener for all messages
      _receivePort!.listen((message) {
        if (!sendPortCompleter.isCompleted && message is SendPort) {
          // First message is the SendPort
          sendPortCompleter.complete(message);
        } else if (message is! SendPort) {
          // Later messages are actual data
          try {
            _handleIsolateMessage(jsonDecode(message));
          } catch (e) {
            log("Error handling message: $e");
          }
        }
      });

      _isolate = await Isolate.spawn(
        _webSocketIsolateEntry,
        _receivePort!.sendPort,
      );

      // Wait for the SendPort
      _sendPort = await sendPortCompleter.future;
    } catch (e) {
      _receivePort?.close();
      _receivePort = null;
      _isolate = null;
      log("Failed to initialize WebSocket isolate: $e");
      throw Exception("Failed to initialize WebSocket isolate: $e");
    }
  }

  void _handleIsolateMessage(Map<String, dynamic> message) {
    final isolateMessage = WebSocketIsolateMessage.fromJson(message);

    if (isolateMessage.type == WebSocketMessageType.socketEvent) {
      final eventName = isolateMessage.data['event'];
      final eventData = isolateMessage.data['data'];

      if (_eventHandlers.containsKey(eventName)) {
        for (var handler in _eventHandlers[eventName]!) {
          handler(eventData);
        }
      }
    }
  }

  Future<void> connect(String token) async {
    if (_sendPort == null) await initialize();

    _connectionCompleter = Completer<void>();

    // Subscribe to connection events
    on('connect', (_) {
      if (_connectionCompleter?.isCompleted == false) {
        _connectionCompleter!.complete();
      }
    });

    _sendPort!.send(jsonEncode(WebSocketIsolateMessage(
      WebSocketMessageType.connect,
      {'token': token},
    ).toJson()));

    return _connectionCompleter!.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('WebSocket connection timed out');
      },
    );
  }

  void disconnect() {
    if (_sendPort != null) {
      _sendPort!.send(jsonEncode(WebSocketIsolateMessage(
        WebSocketMessageType.disconnect,
        {},
      ).toJson()));
    }
  }

  void emit(String event, [dynamic data]) {
    if (_sendPort != null) {
      _sendPort!.send(jsonEncode(WebSocketIsolateMessage(
        WebSocketMessageType.emit,
        {
          'event': event,
          'data': data,
        },
      ).toJson()));
    }
  }

  void on(String event, Function(dynamic) handler) {
    if (!_eventHandlers.containsKey(event)) {
      _eventHandlers[event] = [];

      if (_sendPort != null) {
        _sendPort!.send(jsonEncode(WebSocketIsolateMessage(
          WebSocketMessageType.subscribe,
          {'event': event},
        ).toJson()));
      }
    }

    _eventHandlers[event]!.add(handler);
  }

  void off(String event, [Function(dynamic)? handler]) {
    if (!_eventHandlers.containsKey(event)) return;

    if (handler != null) {
      _eventHandlers[event]!.remove(handler);
    } else {
      _eventHandlers.remove(event);
    }

    if (!_eventHandlers.containsKey(event) || _eventHandlers[event]!.isEmpty) {
      if (_sendPort != null) {
        _sendPort!.send(jsonEncode(WebSocketIsolateMessage(
          WebSocketMessageType.unsubscribe,
          {'event': event},
        ).toJson()));
      }
    }
  }

  void dispose() {
    _eventHandlers.clear();
    _isolate?.kill();
    _receivePort?.close();
    _isolate = null;
    _receivePort = null;
    _sendPort = null;
    _instance = null;
  }
}

void _webSocketIsolateEntry(SendPort mainSendPort) {
  final receivePort = ReceivePort();
  mainSendPort.send(receivePort.sendPort);

  IO.Socket? socket;
  final subscribedEvents = <String>{};
  const String url = 'https://39ce8f47fac5.ngrok-free.app';

  receivePort.listen((message) {
    final isolateMessage =
    WebSocketIsolateMessage.fromJson(jsonDecode(message));

    switch (isolateMessage.type) {
      case WebSocketMessageType.connect:
        final token = isolateMessage.data['token'];

        socket?.disconnect();
        socket?.dispose();

        socket = IO.io(
          url,
          {
            'transports': ['websocket'],
            'autoConnect': true,
            'extraHeaders': {'Authorization': token},
          },
        );

        socket!.connect();

        socket!.onConnect((_) {
          log("[WebSocketIsolate] Socket connected");
          _sendEventToMain(mainSendPort, 'connect', null);
        });

        socket!.onDisconnect((_) {
          log("[WebSocketIsolate] Socket disconnected");
          _sendEventToMain(mainSendPort, 'disconnect', null);
        });

        socket!.onError((error) {
          log("[WebSocketIsolate] Socket error: $error");
          _sendEventToMain(mainSendPort, 'error', error);
        });

        for (final event in subscribedEvents) {
          _subscribeToEvent(socket!, event, mainSendPort);
        }
        break;

      case WebSocketMessageType.disconnect:
        socket?.disconnect();
        break;

      case WebSocketMessageType.emit:
        final event = isolateMessage.data['event'];
        final data = isolateMessage.data['data'];
        socket?.emit(event, data);
        break;

      case WebSocketMessageType.subscribe:
        final event = isolateMessage.data['event'];
        subscribedEvents.add(event);
        if (socket != null) {
          _subscribeToEvent(socket!, event, mainSendPort);
        }
        break;

      case WebSocketMessageType.unsubscribe:
        final event = isolateMessage.data['event'];
        subscribedEvents.remove(event);
        if (socket != null) {
          socket!.off(event);
        }
        break;

      case WebSocketMessageType.socketEvent:
        break;
    }
  });
}

void _subscribeToEvent(IO.Socket socket, String event, SendPort sendPort) {
  socket.on(event, (data) {
    _sendEventToMain(sendPort, event, data);
  });
}

void _sendEventToMain(SendPort sendPort, String event, dynamic data) {
  final message = WebSocketIsolateMessage(
    WebSocketMessageType.socketEvent,
    {
      'event': event,
      'data': data,
    },
  );
  sendPort.send(jsonEncode(message.toJson()));
}
