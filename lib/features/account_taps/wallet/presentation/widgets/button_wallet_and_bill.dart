import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ButtonWalletAndBill extends StatelessWidget {
  const ButtonWalletAndBill(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});

  final Widget icon;
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 343,
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: context.isDarkMode
              ? const Color(0xFFCACEF4)
              : const Color(0xFF0B1035),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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
                  fontSize: 34,
                  color: context.isDarkMode
                      ? const Color(0xFF0D0D0D)
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
