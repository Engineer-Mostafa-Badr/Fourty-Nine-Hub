import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
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
          decoration: const ShapeDecoration(
            color: Color(0xFFD9D9D9),
            shape: OvalBorder(),
          ),
          child: Center(
            child: SvgPicture.asset(svgPath),
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
          style: Styles.mediumText(
            fontSize: 20,
            color: Colors.black.withValues(alpha: 128),
          ),
        ),
      ],
    );
  }
}
