import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CheckBoxItem extends StatelessWidget {
  const CheckBoxItem({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
  });

  final bool value;
  final void Function(bool?)? onChanged;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            side: BorderSide(width: 2,color:  AppColors.getTextColor(context)),
            activeColor: Colors.grey,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Label(
          text: title,
          style: Styles.headerText(
            fontSize: 32,
            height: 1.6,
          ),
        )
      ],
    );
  }
}
