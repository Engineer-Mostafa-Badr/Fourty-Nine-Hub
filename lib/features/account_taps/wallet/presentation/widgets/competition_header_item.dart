import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CompetitionHeaderItem extends StatelessWidget {
  const CompetitionHeaderItem({
    super.key,
    required this.svgPath,
    required this.title,
    required this.value,
  });
  final String svgPath;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: ShapeDecoration(
            color: context.isDarkMode
                ? const Color(0xff333333)
                : const Color(0xFFD9D9D9),
            shape: const OvalBorder(),
          ),
          child: Center(
            child: svgPath.isEmpty
                ? const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                  )
                : SvgPicture.asset(svgPath),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Label(
          text: value,
          style: Styles.headerText(fontSize: 20),
        ),
        Label(
          text: title,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: Styles.mediumText(
            fontSize: 20,
            color: context.isDarkMode
                ? Colors.white
                : Colors.black.withValues(alpha: 128),
          ),
        ),
      ],
    );
  }
}
