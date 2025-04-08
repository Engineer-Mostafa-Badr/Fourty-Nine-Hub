import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ValueAndTitleHeaderProfileInstagram extends StatelessWidget {
  const ValueAndTitleHeaderProfileInstagram({
    super.key,
    required this.value,
    required this.title,
  });

  final String value, title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Label(
          text: value,
          style: Styles.headerText(fontSize: 32),
        ),
        const SizedBox(
          height: 6,
        ),
        Label(
          text: title,
          style: Styles.headerText(fontSize: 32),
        ),
      ],
    );
  }
}
