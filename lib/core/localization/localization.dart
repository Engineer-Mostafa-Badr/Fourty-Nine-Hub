import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppLocalizations tr(BuildContext context) {
  return AppLocalizations.of(context)!;
}

String arEn(BuildContext context, String? ar, String en) {
  if (context.isArabic) {
    return ar ?? en;
  } else {
    return en;
  }
}

extension Localization on BuildContext {
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}
