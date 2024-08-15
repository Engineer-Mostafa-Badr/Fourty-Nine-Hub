import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/core/localization/codegen_loader.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';

abstract interface class LocalizationService {
  static Future<void> init() async {
    await EasyLocalization.ensureInitialized();
  }

  static Widget rootWidget({required Widget child}) {
    return EasyLocalization(
      saveLocale: true,
      supportedLocales: const [Locales.english, Locales.arabic],
      path: 'assets/translations',
      fallbackLocale: Locales.english,
      assetLoader: const CodegenLoader(),
      child: child,
    );
  }
}
