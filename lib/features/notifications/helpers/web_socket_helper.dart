// ignore: unused_import
import 'dart:convert';

import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';

class WebSocketHelper {
  late Socket socket;
  Future<void> notificationListener(Function(Map<String, dynamic> data) notificationCallback) async {
    String? userToken = await getUserToken();

    try {
      socket = io(
          'https://49dev.com',
          OptionBuilder().setTransports(['websocket'])
              // .disableAutoConnect()
              .setExtraHeaders({'authorization': userToken}) // optional
              .build());
      // socket.connect();

      socket.onConnect((_) {
        pr('Connect To Socket successfully ');
      });

      socket.on('NotificationCreated', (data) {
        pr(data);
        // pr(data.runtimeType);
        // pr(jsonDecode(data).runtimeType);
        notificationCallback(jsonDecode(data));
      });

      socket.on('error', (data) {
        pr("error $data");
      });

      socket.onDisconnect((_) => pr('disconnect'));

      socket.onerror((e) => pr('onError $e'));

      pr('socket is connected: ${socket.connected}');
    } catch (e) {
      pr('Exception Thrown $e');
    }
  }

  Future<String?> getUserToken() async {
    return serviceLocator<GetTokensUseCase>().call(const NoParams()).then((value) {
      return value.fold((l) => null, (r) => r?.accessToken);
    });
  }
}
