import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class IncorrectTimeOverlay extends StatelessWidget {
  const IncorrectTimeOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, size: 96, color: Colors.white),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Your device date/time appears to be incorrect.\nPlease update it in system settings.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                print("openAppSettings");
                AppSettings.openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Open Date & Time Settings'),
            ),
          ],
        ),
      ),
    );
  }
}



