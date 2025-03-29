import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class NameAndVerifiedMark extends StatelessWidget {
  const NameAndVerifiedMark({
    super.key,
    required this.isReel,
    required this.isVerified,
    required this.name,
  });

  final bool isReel;
  final bool isVerified;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Label(
          text: name,
          style: Styles.headerText(
            fontSize: 32,
            height: 1.12,
            color: isReel ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(
          width: 3,
        ),
        if (isVerified)
          SvgPicture.asset(
            Assets.verifiedAccountMarkIcon,

          ),
      ],
    );
  }
}
