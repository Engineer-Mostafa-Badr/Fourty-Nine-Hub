import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ButtonLabelCreatePostInstagram extends StatelessWidget {
  const ButtonLabelCreatePostInstagram({
    super.key,
    required this.svgIcon,
    required this.title,
    required this.iconAction,
    required this.onPressed,
  });

  final String svgIcon;
  final String title;
  final IconData iconAction;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Row(
            children: [
              SvgPicture.asset(svgIcon),
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
      ),
    );
  }
}
