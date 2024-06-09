import 'package:url_launcher/url_launcher.dart';

class LaunchURLHelper {
  Future<void> openLocation({
    required double lat,
    required double lng,
  }) async {
    await launchUrl(Uri.parse('https://maps.google.com/?q=$lat,$lng'));
  }
}
