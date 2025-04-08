import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ButtonLabelCreatePostInstagram extends StatelessWidget {
  const ButtonLabelCreatePostInstagram({
    super.key,
    required this.icon,
    required this.title,
    required this.iconAction,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final IconData iconAction;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Icon(
              icon,
            ),
            const SizedBox(
              width: 8,
            ),
            Label(
              text: title,
              style: Styles.headerText(),
            ),
            const Spacer(),
            Icon(
              iconAction,
            )
          ],
        ),
      ),
    );
  }
}
