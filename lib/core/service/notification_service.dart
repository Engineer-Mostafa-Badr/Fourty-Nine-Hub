import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../utils/type_defs.dart';
import '../utils/url_helper.dart';

class NotificationService {
  Future<void> inti() async {
    await _FlutterLocalNotificationHelper.init();

    await _init();

    try {
      await getDeviceTokenId();
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> _init([FutureCallback? onReceiveNewNotification]) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (onReceiveNewNotification != null) onReceiveNewNotification();

      final notification = message.notification;
      final android = notification?.android;
      final apple = notification?.apple;

      if (notification != null && android != null) {
        final image = android.imageUrl;
        _FlutterLocalNotificationHelper.showFCMNotification(
          title: notification.title,
          body: notification.body,
          image: image,
        );
      } else if (notification != null && apple != null) {
        final image = apple.imageUrl;

        _FlutterLocalNotificationHelper.showFCMNotification(
          title: notification.title,
          body: notification.body,
          image: image,
        );
      }

      final link = message.data['Link'];
      final code = message.data['Code'];
      final notificationType = message.data['NotificationType'];

      if (notificationType != 'Normal') {
        _showDialogToNavigate(notificationType, code, link);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        if (onReceiveNewNotification != null) onReceiveNewNotification();

        final link = message.data['Link'];
        final code = message.data['Code'];
        final notificationType = message.data['NotificationType'];
        navigateToPage(
            notificationType: notificationType, code: code, link: link);
      },
    );

    _openNotificationsPageIfAppOpenedFromTerminated();
  }

  _showDialogToNavigate(notificationType, code, link) {
    // TODO
    return null;

    // return showDialog(
    //     context: navigatorKey.currentState!.context,
    //     builder: (_) {
    //       return Column(
    //         mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //             ],
    //       );
    //     });
  }

  Future<void> _openNotificationsPageIfAppOpenedFromTerminated() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      final link = message.data['Link'];
      final code = message.data['Code'];
      final notificationType = message.data['NotificationType'];

      await Future.delayed(const Duration(seconds: 3));
      navigateToPage(
          notificationType: notificationType, code: code, link: link);
    }
  }

  Future<String> getDeviceTokenId() async {
    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    return token!;
  }

  Future<void> cancelAll() => _FlutterLocalNotificationHelper.cancelAll();
}

class _FlutterLocalNotificationHelper {
  static const channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation;
      AndroidFlutterLocalNotificationsPlugin().requestNotificationsPermission();
    }

    flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification),
    ));
  }

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}

  static Future<void> showFCMNotification({
    String? title,
    String? body,
    String? image,
  }) async {
    String? imagePath;
    if (image != '') {
      imagePath = image == null ? null : await _downloadAndSaveFile(image);
    }
    return flutterLocalNotificationsPlugin.show(
      const _NotificationIdGenerator().generate(),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          priority: Priority.max,
          importance: Importance.max,
          largeIcon:
              imagePath == null ? null : FilePathAndroidBitmap(imagePath),
        ),
        iOS: DarwinNotificationDetails(
            attachments: imagePath == null
                ? null
                : [DarwinNotificationAttachment(imagePath)]),
      ),
    );
  }

  static Future<String> _downloadAndSaveFile(String url) async {
    final fileName = UrlHelper.getFileName(url);
    final fileExtension = UrlHelper.getFileExtension(url);

    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName.$fileExtension';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future<void> cancelAll() async =>
      await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> navigateToPage(
    {required String notificationType, String? link, String? code}) {
  // if (notificationType == "Http Link" && link != null)
  // return navigatorKey.currentState!.push(
  //   MaterialPageRoute(
  //     builder: (context) => SafeArea(
  //       child: Scaffold(
  //         body: InAppWebView(
  //           initialOptions: InAppWebViewGroupOptions(
  //             android: AndroidInAppWebViewOptions(
  //               useHybridComposition: true,
  //             ),
  //           ),
  //           initialUrlRequest: URLRequest(
  //             url: Uri.parse(link),
  //           ),
  //         ),
  //       ),
  //     ),
  //   ),
  // );
  // else if (notificationType == "Category")
  //   return navigatorKey.currentState!.push(
  //     MaterialPageRoute(
  //       builder: (context) => CategoryProductsPage(
  //           categoryId: int.tryParse(code!)!,
  //           categoryName: 'notification_category'),
  //       settings: const RouteSettings(name: CategoryProductsPage.routeName),
  //     ),
  //   );
  // else if (notificationType == "Order")
  //   return navigatorKey.currentState!.push(
  //     MaterialPageRoute(
  //       builder: (context) => OrderDetailsPage(orderId: int.tryParse(code!)!),
  //       settings: const RouteSettings(name: CategoryProductsPage.routeName),
  //     ),
  //   );
  // else
  return Future.value();
}

class _NotificationIdGenerator {
  const _NotificationIdGenerator();

  static final random = Random();

  int generate() => random.nextInt(pow(2, 31).toInt() - 1);
}
