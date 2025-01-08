import 'package:easy_localization/easy_localization.dart';

extension StringExtension on String {
  String get localize => this.tr();
  int get toInt => int.parse(this);
  DateTime get toDataTime => DateTime.parse(this);
  Uri get toUri => Uri.parse(this);
  String numberFormat(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    } else {
      return number.toString();
    }
  }
}
