import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import '../call_helper/call_with_notification_helper.dart';
import 'send_notification_params.dart';
import '../../../service_locator/service_locator.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';
import '../../../firebase_options.dart';
import '../../../main.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter/material.dart';
import '../../manage_vibration.dart';

abstract class FcmNotificationHelper {
  Future<void> setup(BuildContext context);
  Future<Either<Exception, String>> getFcmToken();
  Future<String> getFcmUserToken();
  Future onFcmTokenChanges();
  Future<Either<Exception, void>> subscribeTopic(String topic);
  void handleInitialMessage();
  Future<Either<Exception, void>> sendNotification(
      SendNotificationParams params);
  void dispose();
}

class FcmNotificationHelperImpl implements FcmNotificationHelper {
  final FirebaseMessaging _firebaseMessaging;

  FcmNotificationHelperImpl._internal(this._firebaseMessaging);

  // add StreamSubscriptions to control listeners
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  // add flag to prevent multiple setup
  bool _isSetupCompleted = false;

  // add singleton pattern
  static FcmNotificationHelperImpl? _instance;

  factory FcmNotificationHelperImpl(FirebaseMessaging firebaseMessaging) {
    _instance ??= FcmNotificationHelperImpl._internal(firebaseMessaging);
    return _instance!;
  }

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
      // _firebaseMessaging.onTokenRefresh.listen((token) {
      //   log('+++++ FCM Token +++++++++ $token');
      // });
      // cancel old token refresh subscription if exists
      _onTokenRefreshSubscription?.cancel();

      _onTokenRefreshSubscription =
          _firebaseMessaging.onTokenRefresh.listen((token) {
        log('+++++ FCM Token Refreshed +++++++++ $token');

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
      log('+++++ FCM Topic Subscribed +++++++++ $topic');
      return const Right(null);
    } catch (e) {
      return Left(Exception('Unable to subscribe to topic $topic'));
    }
  }

  @override
  Future<void> setup(BuildContext context) async {
    // skip setup if already setup
    if (_isSetupCompleted) {
      log('+++++ FCM already setup, skipping... +++++++++');
      return;
    }

    log('+++++ FCM setup Message +++++++++');

    // Request permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   log('+++++ FCM Message +++++++++ ${message.data}');
    //   await _handleNotification(message,context:context);
    // });

    // dispose old listeners before adding new
    _disposeListeners();

    // add new listeners
    _onMessageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('+++++ FCM Message Received +++++++++ ${message.data}');
      await _handleNotification(message, context: context);
    });

    // FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        log('+++++ FCM Message Opened App +++++++++ ${message.data}');
        AudioPlayer player = AudioPlayer();
        await player.play(AssetSource("audio/notification.mp3"));

        /// TODO: handle on message open app
      },
    );

    // background message handler (this doesn't need to be cancelled as it's static)
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    // add token refresh listener
    await onFcmTokenChanges();

    _isSetupCompleted = true;
    log('+++++ FCM setup completed +++++++++');
  }

  /// dispose all FCM listeners
  void _disposeListeners() {
    log('+++++ Disposing old FCM listeners +++++++++');
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
    _onTokenRefreshSubscription?.cancel();

    _onMessageSubscription = null;
    _onMessageOpenedAppSubscription = null;
    _onTokenRefreshSubscription = null;
  }

  @override
  void dispose() {
    log('+++++ Disposing FCM Helper +++++++++');
    _disposeListeners();
    _isSetupCompleted = false;
    _instance = null; // reassign singleton
  }

  /// reInitialize FCM Helper (useful when logout/login)
  void reset() {
    log('+++++ Resetting FCM Helper +++++++++');
    dispose();
  }

  @override
  Future<void> handleInitialMessage() async {
    // final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    //
    // if (initialMessage != null) {
    AudioPlayer player = AudioPlayer();
    await player.play(AssetSource("audio/notification.mp3"));
    // await _handleNotification(initialMessage); // your handler
    // }
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
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await DI.execute();
    } catch (e) {
      print('Firebase already initialized in background: $e');
    }
  }

  await _handleNotification(message);
}

Future<void> _handleNotification(RemoteMessage message,
    {BuildContext? context}) async {
  log('++++++++++++++notification received++ ${message.data}');

  try {
    // Using Future.delayed to ensure the app is more stable when accessing Provider
    await Future.delayed(const Duration(milliseconds: 300));

    //TODO Get Context to show SnackBar
    final overlayContext = navigatorKey.currentContext!;

    if (context != null) {
      AudioPlayer player = AudioPlayer();
      player.play(AssetSource("audio/notification.mp3"));
      toastification.show(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.notification?.title ?? 'Notification Title',
              style: TextStyle(
                color: context.isDarkMode
                    ? AppColors.whiteColor
                    : AppColors.PRIMARY_COLOR,
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              message.notification?.body ?? 'Notification body',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        autoCloseDuration: const Duration(seconds: 5),
        progressBarTheme:
            ProgressIndicatorThemeData(color: AppColors.SECONDARY_COLOR),
        primaryColor: AppColors.SECONDARY_COLOR,
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        callbacks: ToastificationCallbacks(
          onTap: (toastItem) {
            print('Toast ${toastItem.id} tapped');
            context.push(message.data['path'] ?? '');
          },
        ),
        showProgressBar: true,
      );
    } else {
      showTopSnackBar(
        Overlay.of(overlayContext),
        GestureDetector(
          onTap: () {
            ManageVibration.vibrate();
            Navigator.of(overlayContext).pushNamed(message.data['path'] ?? '');
          },
          child: CustomSnackBar.error(
            message:
                "${message.notification?.title ?? 'Notification Title'} \n${message.notification?.body ?? 'Notification body'}",
            maxLines: 3,
          ),
        ),
      );
    }

    if (!serviceLocator.isRegistered<CallWithNotificationHelper>()) {
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        await DI.execute();
      } catch (e) {
        print('Firebase already initialized in notification handler: $e');
      }
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
