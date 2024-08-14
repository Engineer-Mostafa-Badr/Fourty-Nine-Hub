import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/routes/pages.dart';

String getLang() {
  return AppPages
      .router.configuration.navigatorKey.currentContext!.locale.languageCode;
}

void changeLang({required Locale locale}) {
  final context = AppPages.router.configuration.navigatorKey.currentContext!;

  context.setLocale(locale);
}
