import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../res/style/styles.dart';

class ButtonLabelCreatePostInstagram extends StatelessWidget {
  const ButtonLabelCreatePostInstagram({
    super.key,
    required this.svgIcon,
    required this.title,
    required this.iconAction,
    required this.onPressed,
    required this.labelColor,
    // required this.onPressedActionButton,
  });

  final String svgIcon;
  final String title;
  final IconData iconAction;
  final void Function()? onPressed;
  final Color? labelColor;
  // final void Function()? onPressedActionButton;

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
                width: 10,
              ),
              Label(
                text: title,
                style: Styles.headerText(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: labelColor,
                ),
              ),
              const Spacer(),
              Icon(
                iconAction,
                size: 12,
                color: context.isDarkMode
                    ? const Color(0xff808080)
                    : const Color(0x80000000),
              ),
              // IconButton(
              //   icon: Icon(
              //     iconAction,
              //     size: 12,
              //   ),
              //   onPressed: onPressedActionButton,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
