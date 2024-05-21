import 'package:flutter/material.dart';

class Sizer extends StatelessWidget {
  final double? height;
  final double? width;

  const Sizer({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 10,
      width: width ?? 10,
    );
  }
}
