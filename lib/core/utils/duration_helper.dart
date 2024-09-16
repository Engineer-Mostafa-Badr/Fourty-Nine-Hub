import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

class DurationHelper {
  String sinceTime({required Duration duration}) {
    return duration.inDays > 0
        ? "${duration.inDays} ${LocaleKeys.days.localize}"
        : duration.inHours > 0
            ? "${duration.inHours} ${LocaleKeys.hours.localize}"
            : "${duration.inMinutes} ${LocaleKeys.minute.localize}";
  }
}
