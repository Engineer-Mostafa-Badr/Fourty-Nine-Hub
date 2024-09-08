// ignore: unused_import
import 'dart:async';
import 'dart:convert';

import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';

class WebSocketHelper {
  final Socket socket;

  WebSocketHelper({required this.socket});
  Future<void> notificationListener(
      Function(Map<String, dynamic> data) notificationCallback) async {
    try {
      socket.io.options?['extraHeaders']?['authorization'] =
          await getUserToken();
      socket.connect();
      socket.onConnect((_) {
        pr('Connect To Socket successfully');
      });

      socket.on('NotificationCreated', (data) {
        pr(data);
        notificationCallback(jsonDecode(data));
      });

      socket.on('error', (data) {
        pr("error $data");
      });

      socket.onDisconnect((_) => pr('disconnect'));

      socket.onerror((e) => pr('onError $e'));
    } catch (e) {
      pr('Exception Thrown $e');
    }
  }

  Future<String?> getUserToken() async {
    return serviceLocator<GetTokensUseCase>()
        . //
        call(const NoParams())
        . //
        then((value) => value.fold((l) => null, (r) => r?.accessToken));
  }
}
