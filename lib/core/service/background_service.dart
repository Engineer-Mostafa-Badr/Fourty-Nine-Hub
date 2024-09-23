import 'package:flutter/services.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

abstract class BackgroundService {
  static const _platform = MethodChannel('com.app.fourtynine/websocket');

  static Future<void> startWebSocketService(String? token) async {
    try {
      await _platform.invokeMethod('startWebSocketService', {'token': token});
    } on PlatformException catch (e) {
      CliLogger.error(
          "Failed to start service (PlatformException) : '${e.message}'.");
    } catch (e) {
      CliLogger.error("Failed to start service: '$e'.");
    }
  }


  static Future<void> reStartWebSocketService(String? token) async {
    try {
      await _platform.invokeMethod('updateWebSocketToken', {'token': token});
    } on PlatformException catch (e) {
      CliLogger.error(
          "Failed to start service (PlatformException) : '${e.message}'.");
    } catch (e) {
      CliLogger.error("Failed to start service: '$e'.");
    }
  }
}