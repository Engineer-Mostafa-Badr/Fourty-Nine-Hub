import 'package:intl/intl.dart';

String numAr(num number) {
  final formatter = NumberFormat('#,##0.###', 'ar_EG');
  return formatter.format(number);
}
String convertToArabicNumbers(String input) {
  const englishToArabic = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  return input.split('').map((char) {
    return englishToArabic[char] ?? char;
  }).join();
}
