import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import 'font_manager.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // width: 140,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [Colors.red.shade800, AppColors.PRIMARY_COLOR],
            stops: [0.4, 0.6], //
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: FontSize.s16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}