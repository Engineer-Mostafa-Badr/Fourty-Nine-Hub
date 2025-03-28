import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ButtonUploadImage extends StatelessWidget {
  const ButtonUploadImage({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.height = 44,
  });

  final Widget icon;
  final String label;
  final double height;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 343,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: const Color(0xFF0B1035),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(
                width: 4,
              ),
              Label(
                text: label,
                style: Styles.headerText(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
