import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LaunchURLHelper {
  Future<void> openLocation({
    required double lat,
    required double lng,
  }) async {
    await launchUrl(Uri.parse('https://maps.google.com/?q=$lat,$lng'));
  }

  Future<void> call({required String phone}) async {
    await launchUrlString('tel: $phone');
  }
  // https://wa.me/15551234567

  Future<void> openWhatsapp({required String phone}) async {
    await launchUrlString('https://wa.me/$phone');
  }
}
