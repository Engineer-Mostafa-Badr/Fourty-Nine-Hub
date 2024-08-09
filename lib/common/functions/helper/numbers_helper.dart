import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:intl/intl.dart';

abstract class NumbersHelper {
  static String formatThousands({required num number}) {
    return NumberFormat('#,###,###').format(number);
  }
}

extension NumberHelper on num {
  String get toShortScale {
    String answer = '';
    String number = toString();

    if (this >= 1000000000) {
      answer = (this / 1000000000).toStringAsFixed(0);
      if (number[answer.length] != '0') {
        answer += '.${number[answer.length]}';
      }
      answer += 'B';
    } else if (this >= 1000000) {
      answer = (this / 1000000).toStringAsFixed(0);
      if (number[answer.length] != '0') {
        answer += '.${number[answer.length]}';
      }
      answer += 'M';
    } else if (this >= 1000) {
      answer = (this / 1000).toStringAsFixed(0);
      if (number[answer.length] != '0') {
        answer += '.${number[answer.length]}';
      }
      answer += 'K';
    } else {
      answer = round().toString();
    }
    return answer;
  }
}
