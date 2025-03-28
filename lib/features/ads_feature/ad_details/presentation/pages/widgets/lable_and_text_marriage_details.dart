import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class LableAndTextMarriageDetails extends StatelessWidget {
  const LableAndTextMarriageDetails({
    super.key,
    required this.lable,
    required this.text,
  });
  final String lable, text;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$lable: ',
            style: Styles.headerText(
              fontWeight: FontWeight.w500,
              fontSize: 32,
              color: AppColors.SECONDARY_COLOR_DARK2,
              height: 1.60,
            ),
          ),
          TextSpan(
            text: text,
            style: Styles.headerText(
              fontSize: 32,
              height: 1.60,
            ),
          ),
        ],
      ),
    );
  }
}
