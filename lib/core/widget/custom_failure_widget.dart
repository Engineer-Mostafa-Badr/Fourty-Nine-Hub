import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../res/style/styles.dart';
import '../localization/locale_keys.g.dart';

class CustomFailureWidget extends StatelessWidget {
  final String title;

  final void Function() onPressed;
  final String? buttonTitle;
  const CustomFailureWidget({
    super.key,
    required this.title,
    required this.onPressed,
    this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Text(
          title,
          style: Styles.headerText(
            fontSize: 38,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(
          flex: 5,
        ),
        InkWell(
          onTap: onPressed,
          child: Container(
            width: 343,
            height: 44,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.60, 0.50),
                end: Alignment(1.00, 0.50),
                colors: [
                  (context.isDarkMode
                      ? const Color(0xFFCAD0F4)
                      : const Color(0xFF0B1035)),
                  Color(0xFFF33D49)
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (buttonTitle == null) ...[
                  SvgPicture.asset(context.isDarkMode
                      ? Assets.refreshIconDark
                      : Assets.refreshIcon),
                  const SizedBox(
                    width: 0.5,
                  ),
                ],
                Label(
                  text: buttonTitle ?? LocaleKeys.refresh.localize,
                  style: Styles.headerText(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color:
                        context.isDarkMode ? Color(0xFF0D0D0D) : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // SizedBox(
        //   width: double.infinity,
        //   child: ButtonWalletAndBill(
        //     icon: const Icon(
        //       Icons.refresh_sharp,
        //       color: Colors.white,
        //     ),
        //     label: LocaleKeys.tryAgain.localize,
        //     onPressed: onPressed,
        //   ),
        // ),
      ],
    );
  }
}
