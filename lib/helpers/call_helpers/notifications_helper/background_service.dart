import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// Main service initialization
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // Flutter local notifications setup
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    '49_hub_service_channel',
    '49 HUB Service Channel',
    description: 'Channel for Call Service',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Service initialization
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: '49_hub_service_channel',
      initialNotificationTitle: '49 HUB',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

// iOS background handler
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // Keep the app awake
  WakelockPlus.enable();

  return true;
}

// Main service handler
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // Enable wakelock to keep device awake during calls
  WakelockPlus.enable();

  // Shared preferences to store call state
  final prefs = await SharedPreferences.getInstance();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Handle service stop
  service.on('stopService').listen((event) {
    service.stopSelf();
    WakelockPlus.disable();
  });

  // Call state management
  bool isCallActive = false;
  String callType = '';

  // Handle start call
  service.on('startCall').listen((event) async {
    if (event == null) return;

    callType = event['callType'] ?? 'voice';
    isCallActive = true;

    // Update notification
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: '49 hub in Progress',
        content: '49 HUB',
      );
    }

    // Save call state
    await prefs.setBool('isCallActive', true);
    await prefs.setString('callType', callType);

    // Your call initialization code here
    // ...
  });

  // Handle end call
  service.on('endCall').listen((event) async {
    isCallActive = false;

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'Call Ended',
        content: 'Call service will stop soon',
      );
    }

    // Clear call state
    await prefs.setBool('isCallActive', false);

    // Your call termination code here
    // ...

    // Wait a bit before stopping service
    await Future.delayed(const Duration(seconds: 2));
    service.stopSelf();
    WakelockPlus.disable();
  });

  // Periodic check for call status
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    // Send call status to UI
    service.invoke(
      'callStatus',
      {
        'isActive': isCallActive,
        'callType': callType,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  });
}
