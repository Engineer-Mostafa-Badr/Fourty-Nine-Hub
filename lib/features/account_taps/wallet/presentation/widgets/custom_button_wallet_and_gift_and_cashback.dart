import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CustomButtonWalletAndGiftAndCashback extends StatelessWidget {
  const CustomButtonWalletAndGiftAndCashback({
    super.key,
    required this.title,
    required this.onPressed,
    required this.status,
    this.activeColor,
    this.disableColor,
    this.padding,
    this.textStyle,
  });

  final String title;
  final void Function() onPressed;
  final Color? activeColor;
  final Color? disableColor;
  final double? padding;
  final bool status;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: title,
      style: textStyle ??
          Styles.headerText(
            color: context.isDarkMode ? const Color(0xff0D0D0D) : Colors.white,
            fontSize: 32,
          ),
      backColor: status
          ? (activeColor ??
              (context.isDarkMode
                  ? const Color(0xffF45560)
                  : const Color(0xffF33D49)))
          : (disableColor ??
              (context.isDarkMode
                  ? const Color(0xB3F45560)
                  : const Color(0xB3F33D49))),
      onPressed: status ? onPressed : () {},
      padding: padding,
    );
  }
}
