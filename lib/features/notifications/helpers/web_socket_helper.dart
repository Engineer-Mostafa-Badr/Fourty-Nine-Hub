// ignore: unused_import
import 'dart:async';
import 'dart:convert';

import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:fourtyninehub/shared_web_socket.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:audioplayers/audioplayers.dart';

class WebSocketHelper {
  // final Socket socket;

  WebSocketHelper();

  bool isCalled = true;
  // Future<void> connect() async {
  //   socket.connect();
  //   socket.onConnectError(
  //     (data) {
  //       pr("Socket Error is ${data}");
  //     },
  //   );
  //   socket.onError(
  //     (data) {
  //       pr("Socket Error is ${data}");
  //     },
  //   );
  // }

  Future<void> notificationListener(
      Function(Map<String, dynamic> data) notificationCallback) async {
    try {
      // pr(await CacheManager.getAccessToken());
      // pr('notificationListener is called ');
      // SharedWebSocket.instance.socket!.disconnect();
      // SharedWebSocket.instance.socket!.io.close();
      // SharedWebSocket.instance.socket!.io.cleanup();
      // pr('token saved in the instance of the socket is ');
      // pr(SharedWebSocket.instance.socket!.io.options?['extraHeaders']?['authorization']);
      // pr('saved token is ');
      // pr(await CacheManager.getAccessToken());

      // socket.io.options?['extraHeaders']?['authorization'] =
      //     await TokenManager.getAccessToken();
      // SharedWebSocket.instance.socket!.connect();
      // SharedWebSocket.instance.socket!.onConnect((_) {
      //   pr('Connect To Socket successfully ');
      // });

      SharedWebSocket.socket!.on('getRooms', (data) => pr('get rooms : $data'));

      SharedWebSocket.socket!.on('NotificationCreated', (data) {
        pr('NotificationCreated Event is recieved and the data is: ');
        pr(data);
        Map<String, dynamic> json = jsonDecode(data);
        AudioPlayer player = AudioPlayer();
        if (json['metadata']['newTrip'] ?? false) {
          // log(json['metadata']['newTrip'].toString(),
          //     name: "Ljkdlfjsdlfkjsldkfjsldkjflskdjf");
          Future.delayed(
            const Duration(seconds: 2),
                () {
              player.play(AssetSource("audio/u_have_a_new_ride_ar.mp3"));
            },
          );
        }
        notificationCallback(jsonDecode(data));

      });


      SharedWebSocket.socket!.on('error', (data) {
        pr("error $data");
      });

      SharedWebSocket.socket!.onDisconnect((_) => pr('disconnect'));

      SharedWebSocket.socket!.onerror((e) => pr('onError $e'));
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
