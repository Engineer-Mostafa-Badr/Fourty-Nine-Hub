// import 'dart:convert';
// import 'dart:math';

// import 'package:crypto/crypto.dart';

// class SocialLoginHelper {
//   String generateNonce([int length = 32]) {
//   const charset =
//       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//   final random = Random.secure();
//   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
//       .join();
// }

// /// Returns the sha256 hash of [input] in hex notation.
// String sha256ofString(String input) {
//   final bytes = utf8.encode(input);
//   final digest = sha256.convert(bytes);
//   return digest.toString();
// }
// }


import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


//! ===== Device ID Helper =====
class DeviceHelper {
  static Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown_ios_device';
    }

    return 'unknown_device';
  }
}

//! ===== FCM Helper Class =====
// class FCMHelper {
//   static Future<String?> getFcmToken() async {
//     try {
//       final token = await FirebaseMessaging.instance.getToken();
//       print('FCM Token: $token');
//       return token;
//     } catch (e) {
//       print('Error getting FCM token: $e');
//     }
//     return null;
//   }
// }


class FCMHelper {
  static Future<String?> getFcmToken() async {
    try {
      // Request permission first
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await FirebaseMessaging.instance.getToken();
        log('FCM Token: $token');
        return token;
      } else {
        log('User declined or has not accepted permission');
        return null;
      }
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }

  static Future<void> setupFCM() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }
}


//! Helper method to get device ID
  // Future<String> _getDeviceId() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isAndroid) {
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     return androidInfo.id;
  //   } else if (Platform.isIOS) {
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     return iosInfo.identifierForVendor ?? 'unknown_ios_device';
  //   }
  //   return 'unknown_device';
  // }
