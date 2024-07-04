import 'package:share_plus/share_plus.dart';

class ShareHelper {
  Future<void> share({
    required String text,
    required String subject,
  }) async {
     await Share.share(text, subject: subject);
  }
}
