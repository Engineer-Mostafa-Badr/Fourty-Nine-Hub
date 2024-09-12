import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/firebase_notification_entity.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:go_router/go_router.dart';

// FirebaseHelper firebaseHelper = FirebaseHelper();

class FirebaseHelper {
  late BuildContext context;

  bool notificationPageLoaded = false;

  void initFirebaseHelper(BuildContext context) {
    this.context = context;
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    message.messageId;
  }

  void requestPermisson(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      sound: true,
      announcement: false,
      provisional: false,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      'User granted Permisson';
    } else {
      "User didn't give the application permisson";
    }
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        // message.notification!.title.prm('$t firebase messaging listener - notification title');
        // message.notification!.body.prm('$t firebase messaging listener - notification body');
        // customSnackBar(
        //     context: context, title: "${message.notification!.title}\n${message.notification!.body}", durationSeconds: 3);
        AlertDialog alert = AlertDialog(
          title: Text(message.notification!.title ?? 'Notifcation Title'),
          content: Text(message.notification!.body ?? 'Notification Body'),
          actions: const [],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      },
    );
  }

  Future<void> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    pr(token);
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // pr(message.data);
    // pr(message.data.runtimeType);
    FirebaseNotificationEntitiy firebaseNotificationEntitiy = FirebaseNotificationEntitiy.fromMap(message.data);
    // pr(firebaseNotificationEntitiy);
    if (firebaseNotificationEntitiy.status == 'success' && !notificationPageLoaded) {
      notificationPageLoaded = true;
      Future.delayed(const Duration(seconds: 3)).then((value) => notificationPageLoaded = false);
      // pr('status is success ');
      pr(firebaseNotificationEntitiy.path);
      pr(firebaseNotificationEntitiy.payload);
      context.push(firebaseNotificationEntitiy.path ?? '', extra: firebaseNotificationEntitiy.payload);
    }
  }
}
