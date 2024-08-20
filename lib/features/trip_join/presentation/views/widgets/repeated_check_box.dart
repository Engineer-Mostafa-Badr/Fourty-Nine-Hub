import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class RepeatedCheckBox extends StatelessWidget {
  const RepeatedCheckBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: true,
          onChanged: (value) {},
          checkColor: Colors.white,
          activeColor: AppColors.PRIMARY_COLOR,
        ),
        Text('Repeated', style: Styles.headerText()),
      ],
    );
  }
}
