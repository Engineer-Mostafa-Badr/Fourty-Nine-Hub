import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
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
        log('+++++ FCM Token +++++++++ $token');

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
      log('+++++ FCM Topic +++++++++ $topic');
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
      log('+++++ FCM Message +++++++++ ${message.data}');
      await _handleNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        /// TODO: handle on message open app
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
      print('++++++++++++++notification sent++ ${params.toMap()}');
      final token = await _generateAccessKey();
      print('Access token inside sendNotification $token');
      if (token == null) {
        log('++++++++++++++notification sent++ no data');

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
  print("++++++++++++++_generateAccessKey+++++++++++++");
  final jsonString =
      await rootBundle.loadString('assets/keys/service_account_key.json');
  print("++++++++++++++jsonString+++++++++++++ $jsonString");
  final serviceAccount = ServiceAccountCredentials.fromJson(jsonString);
  print("++++++++++++++serviceAccount+++++++++++++ $serviceAccount");
  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  print("++++++++++++++scopes+++++++++++++ $scopes");
  final authClient = await clientViaServiceAccount(serviceAccount, scopes);
  print("++++++++++++++authClient+++++++++++++ $authClient");
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
    await DI.execute();
  }

  await _handleNotification(message);
}

Future<void> _handleNotification(RemoteMessage message) async {
  log('++++++++++++++notification received++ ${message.data}');

  try {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!serviceLocator.isRegistered<CallWithNotificationHelper>()) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await DI.execute();
    }
    
    if (serviceLocator.isRegistered<CallWithNotificationHelper>()) {
      print('+++++ CallWithNotificationHelper +++++++++');
      serviceLocator<CallWithNotificationHelper>()
          .handleIncomingCallNotification(message.data);
    } else {
      log('Warning: CallWithNotificationHelper not registered in serviceLocator');
    }
  } catch (e, stackTrace) {
    // Prevent app crashes by handling the exception
    log('Error handling notification: $e');
    log('Stack trace: $stackTrace');
  }

  // TODO: Handle other notification types
}
