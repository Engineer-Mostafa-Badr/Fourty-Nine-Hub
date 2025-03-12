import 'package:flutter/material.dart';

class CustomColorCircleWidget extends StatelessWidget {
  final Color? firstColor;

  const CustomColorCircleWidget({super.key, this.firstColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: firstColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
