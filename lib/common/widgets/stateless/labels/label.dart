import 'package:flutter/material.dart';

import '../../../../res/style/styles.dart';

class Label extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final Color? color;
  const Label(
      {super.key,
      required this.text,
      this.style,
      this.overflow,
      this.textAlign,
      this.maxLines,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? Styles.mediumText(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      // maxLines: maxLines,
    );
  }
}
