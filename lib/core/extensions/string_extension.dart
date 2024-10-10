import 'package:easy_localization/easy_localization.dart';

extension StringExtension on String {
  String get localize => this.tr();
  int get toInt => int.parse(this);
  DateTime get toDataTime => DateTime.parse(this);
}
