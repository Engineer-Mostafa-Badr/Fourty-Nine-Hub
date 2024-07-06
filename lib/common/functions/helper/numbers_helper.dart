import 'package:intl/intl.dart';

abstract class NumbersHelper {
  static String formatThousands({required num number}) {
    return NumberFormat('#,###,###').format(number);
  }
}
