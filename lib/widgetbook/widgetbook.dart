import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'custom_directories.dart';
import 'utils/provider_wrapper.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: customDirectories,
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                canvasColor: Colors.white,
              ),
            ),
            WidgetbookTheme(name: 'Dark', data: ThemeData.dark()),
          ],
        ),
        TextScaleAddon(
          min: 0.1,
          max: 10,
        ),
        LocalizationAddon(
          locales: [const Locale('en', 'US')],
          localizationsDelegates: [
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
          ],
        ),
        DeviceFrameAddon(
          devices: [
            ...Devices.ios.all,
            ...Devices.android.all,
          ],
        ),
      ],
      // Wrap the entire app with providers to ensure they're available globally
      appBuilder: (context, child) => WidgetbookProviderWrapper(child: child),
    );
  }
}
