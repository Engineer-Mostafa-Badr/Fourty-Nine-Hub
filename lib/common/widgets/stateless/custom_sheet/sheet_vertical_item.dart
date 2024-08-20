import 'package:flutter/cupertino.dart';

class CustomSheetModel {
  final dynamic value;
  final String text;
  IconData? iconData;
  bool isHidden;

  CustomSheetModel({
    required this.value,
    required this.text,
    this.iconData,
    this.isHidden = false,
  });
}
