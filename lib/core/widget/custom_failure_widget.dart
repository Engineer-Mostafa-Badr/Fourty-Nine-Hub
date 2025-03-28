import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../res/style/styles.dart';
import '../localization/locale_keys.g.dart';

class CustomFailureWidget extends StatelessWidget {
  const CustomFailureWidget({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final void Function() onPressed;

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
              gradient: const LinearGradient(
                begin: Alignment(-0.60, 0.50),
                end: Alignment(1.00, 0.50),
                colors: [Color(0xFF0B1035), Color(0xFFF33D49)],
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
                SvgPicture.asset(Assets.refreshIcon),
                const SizedBox(
                  width: 0.5,
                ),
                Label(
                  text: LocaleKeys.refresh.localize,
                  style: Styles.headerText(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
