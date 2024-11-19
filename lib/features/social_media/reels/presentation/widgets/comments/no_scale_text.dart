import 'package:flutter/material.dart';

class NoScaleText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  const NoScaleText(
      this.data, {
        super.key,
        this.style,
        this.textAlign,
        this.maxLines,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textScaler: const TextScaler.linear(1),
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}
