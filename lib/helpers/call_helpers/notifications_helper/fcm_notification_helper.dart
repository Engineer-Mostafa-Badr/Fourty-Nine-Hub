import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/utils/custom_show_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../features/notifications/presentation/widgets/notification_snackbar.dart';
import '../../../main.dart';
import '../call_helper/call_with_notification_helper.dart';
import 'send_notification_params.dart';
import '../../../service_locator/service_locator.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';
import '../../../firebase_options.dart';

abstract class FcmNotificationHelper {
  Future<void> setup();

  Future<Either<Exception, String>> getFcmToken();

  Future<String> getFcmUserToken();

  Future onFcmTokenChanges();

  Future<Either<Exception, void>> subscribeTopic(String topic);

  void handleInitialMessage();

  Future<Either<Exception, void>> sendNotification(
      SendNotificationParams params);
}

class FcmNotificationHelperImpl implements FcmNotificationHelper {
  final FirebaseMessaging _firebaseMessaging;

  FcmNotificationHelperImpl(
    this._firebaseMessaging,
  );

  @override
  Future<Either<Exception, String>> getFcmToken() async {
    try {
      final result = await _firebaseMessaging.getToken();
      if (result == null) {
        return Left(Exception('Unable to get your notification token'));
      }
      print('+++++ FCM Token +++++++++ $result');
      return Right(result);
    } catch (e) {
      return Left(Exception('Unable to get your notification token'));
    }
  }

  @override
  Future<String> getFcmUserToken() async {
    // try {
    //   final result = await _firebaseMessaging.getToken();
    //   if (result == null) {
    //     return Left(Exception('Unable to get your notification token'));
    //   }
    //   print('+++++ FCM Token +++++++++ $result');
    //   return Right(result);
    // } catch (e) {
    //   return Left(Exception('Unable to get your notification token'));
    // }

    final result = await _firebaseMessaging.getToken();

    return result!;
  }

  @override
  Future onFcmTokenChanges() async {
    try {
      _firebaseMessaging.onTokenRefresh.listen((token) {
        debugPrint('+++++ FCM Token +++++++++ $token');

        /// TODO: send token to server
      });
    } catch (e) {
      return Left(Exception('Unable to get your notification token'));
    }
  }

  @override
  Future<Either<Exception, void>> subscribeTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('+++++ FCM Topic +++++++++ $topic');
      return const Right(null);
    } catch (e) {
      return Left(Exception('Unable to subscribe to topic $topic'));
    }
  }

  @override
  Future<void> setup() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('+++++ FCM Message +++++++++ ${message.data}');
      // await _handleNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        /// TODO: handle on message open app
        debugPrint('+++++ FCM Message +++++++++ ${message.data}');
        await _handleNotification(message);
      },
    );
  }

  @override
  void handleInitialMessage() {
    /// TODO: handle initial message
  }

  @override
  Future<Either<Exception, void>> sendNotification(
      SendNotificationParams params) async {
    try {
      final token = await _generateAccessKey();
      print('Access token inside sendNotification $token');
      if (token == null) {
        debugPrint('++++++++++++++notification sent++ no data');

        return Left(Exception('Unable to send notification'));
      }

      print('+++++ Token +++++++++ $token');

      print('++++++++++++++notification sent++ ${params.toMap()}');

      final result = await post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/app-af0a7/messages:send'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(params.toMap()),
      );
      print('result of sendNotification ${result.body}');
      if (result.statusCode > 199 && result.statusCode < 300) {
        print('+++++++++ ${json.decode(result.body)} ++++++++++');
        return const Right(null);
      }

      return Left(Exception('Unable to send notification'));
    } catch (e) {
      return Left(Exception('Unable to send notification $e'));
    }
  }
}

Future<String?> _generateAccessKey() async {
  final jsonString =
      await rootBundle.loadString('assets/keys/service_account_key.json');
  final serviceAccount = ServiceAccountCredentials.fromJson(jsonString);
  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  final authClient = await clientViaServiceAccount(serviceAccount, scopes);
  final accessToken = authClient.credentials.accessToken;
  print('Access token is ${accessToken.data}');
  return accessToken.data;
}

@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  if (!serviceLocator.isRegistered<CallWithNotificationHelper>()) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // await DI.execute();
  }

  await _handleNotificationOnBackground(message);
}

Future<void> _handleNotification(RemoteMessage message) async {
  debugPrint('++++++++++++++notification received (data): ${message.data}');
  debugPrint('++++++++++++++notification received (title): ${message.notification?.title ?? 'No title'}');
  debugPrint('++++++++++++++notification received (body): ${message.notification?.body ?? 'No body'}');


  try {
    // Using Future.delayed to ensure the app is more stable when accessing Provider
    await Future.delayed(const Duration(milliseconds: 300));

    //TODO Get Context to show SnackBar
    final overlayContext = navigatorKey.currentContext!;
    showTopSnackBar(
      Overlay.of(overlayContext),
      GestureDetector(
        onTap: () {
          overlayContext.push(message.data['path'] ?? '');
        },
        child: CustomSnackBar.error(
          message: "${message.notification?.title ?? 'Notification Title'} \n${message.notification?.body ?? 'Notification body'}",
          maxLines: 3,
        ),
      ),
    );

    if (serviceLocator.isRegistered<CallWithNotificationHelper>()) {
      serviceLocator<CallWithNotificationHelper>()
          .handleIncomingCallNotification(message.data);
    } else {
      debugPrint('Warning: CallWithNotificationHelper not registered in serviceLocator');
    }
  } catch (e, stackTrace) {
    // Prevent app crashes by handling the exception
    debugPrint('Error handling notification: $e');
    debugPrint('Stack trace: $stackTrace');
  }

  // TODO: Handle other notification types
}
Future<void> _handleNotificationOnBackground(RemoteMessage message) async {
  debugPrint('++++++++++++++notification received (data): ${message.data}');
  debugPrint('++++++++++++++notification received (title): ${message.notification?.title ?? 'No title'}');
  debugPrint('++++++++++++++notification received (body): ${message.notification?.body ?? 'No body'}');


  try {
    // Using Future.delayed to ensure the app is more stable when accessing Provider
    await Future.delayed(const Duration(milliseconds: 300));
    if (serviceLocator.isRegistered<CallWithNotificationHelper>()) {
      serviceLocator<CallWithNotificationHelper>()
          .handleIncomingCallNotification(message.data);
    } else {
      debugPrint('Warning: CallWithNotificationHelper not registered in serviceLocator');
    }
  } catch (e, stackTrace) {
    // Prevent app crashes by handling the exception
    debugPrint('Error handling notification: $e');
    debugPrint('Stack trace: $stackTrace');
  }

  // TODO: Handle other notification types
}
