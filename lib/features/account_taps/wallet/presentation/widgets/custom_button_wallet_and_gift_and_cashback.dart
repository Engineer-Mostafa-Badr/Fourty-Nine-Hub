import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CustomButtonWalletAndGiftAndCashback extends StatelessWidget {
  const CustomButtonWalletAndGiftAndCashback({
    super.key,
    required this.title,
    required this.onpressed,
    this.color,
    this.padding,
  });

  final String title;
  final void Function() onpressed;
  final Color? color;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: title,
      style: Styles.headerText(color: Colors.white, fontSize: 32),
      backColor: color ?? const Color(0xffF33D49),
      onPressed: onpressed,
      padding: padding,
    );
  }
}
