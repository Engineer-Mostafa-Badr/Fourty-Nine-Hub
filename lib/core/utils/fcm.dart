import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getFcmToken() async {
  try {
    final token = await FirebaseMessaging.instance.getToken();
    return token;
  } catch (_) {}
  return null;
}
