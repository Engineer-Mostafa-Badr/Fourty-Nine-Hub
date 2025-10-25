import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';

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
            color:
                (!context.isDarkMode && isReel) ? Colors.white : Colors.black,
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
