import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class IconAndValueWidget extends StatelessWidget {
  const IconAndValueWidget({
    super.key,
    required this.icon,
    required this.value,
  });

  final Widget icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: icon,
        ),
        const SizedBox(
          width: 6,
        ),
        Label(
          text: value,
          style: Styles.mediumText(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1.12,
          ),
        ),
      ],
    );
  }
}