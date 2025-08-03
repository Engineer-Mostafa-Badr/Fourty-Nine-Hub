import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';

class IconAndValueWidget extends StatelessWidget {
  const IconAndValueWidget({
    super.key,
    required this.icon,
    required this.value,
    required this.onPressed,
  });

  final Widget icon;
  final String value;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
      ),
    );
  }
}
