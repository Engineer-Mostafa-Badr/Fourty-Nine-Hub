import 'package:flutter/material.dart';

import '../../../../res/style/styles.dart';

class Label extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  const Label({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? Styles.mediumText(),
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      
      maxLines: maxLines,
    );
  }
}
