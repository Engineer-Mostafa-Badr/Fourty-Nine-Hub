import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static final StreamController<String> _actionStream = StreamController<String>.broadcast();
  static Stream<String> get actionStream => _actionStream.stream;

  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("📢 Notification response: ${response.actionId} | payload: ${response.payload}");

        // Handle both action buttons and notification tap
        if (response.actionId != null && response.actionId!.isNotEmpty) {
          _actionStream.add(response.actionId!);
        } else {
          // When tapping notification body (no actionId)
          _actionStream.add('tap');
        }
      },
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required List<AndroidNotificationAction> actions,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'tube_player_channel',
      'Tube Player Background',
      channelDescription: 'Plays tube videos in background',
      importance: Importance.high,
      priority: Priority.high,
      enableLights: false,
      playSound: false,
      ongoing: true, // Makes notification persistent
      autoCancel: false, // Prevents dismissal
      showWhen: false,
      actions: actions,
      // Important: This makes the notification visible in foreground
      visibility: NotificationVisibility.public,
      // Add category for media playback
      category: AndroidNotificationCategory.transport,
    );

    final details = NotificationDetails(android: androidDetails);
    await _notifications.show(id, title, body, details);
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  void dispose() {
    if (!_actionStream.isClosed) {
      _actionStream.close();
    }
  }
}