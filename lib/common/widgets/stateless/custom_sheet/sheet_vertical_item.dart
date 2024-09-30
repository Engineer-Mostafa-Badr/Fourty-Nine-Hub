import 'package:flutter/cupertino.dart';

class CustomSheetModel {
  final dynamic value;
  final String text;
  IconData? iconData;
  String? image;
  bool isHidden;

  CustomSheetModel({
    required this.value,
    required this.text,
    this.image,
    this.iconData,
    this.isHidden = false,
  });
}
