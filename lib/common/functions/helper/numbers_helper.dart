import 'package:intl/intl.dart';

abstract class NumbersHelper {
  static String formatThousands({required num number}) {
    return NumberFormat('#,###,###').format(number);
  }
}

extension NumberHelper on num {
  
  String get toShortScale {
    return NumberFormat.compact(locale: "en_US", explicitSign: false).format(this);
  }
}
