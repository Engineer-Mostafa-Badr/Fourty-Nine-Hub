import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class ReadMoreLabel extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? trimLines;
  const ReadMoreLabel(
      {super.key,
      required this.text,
      this.style,
      this.textAlign,
      this.trimLines});

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      style: style ?? Styles.mediumText(),
      textAlign: textAlign,
      trimMode: TrimMode.Line,
      trimLines: trimLines ?? 3,
      colorClickableText: Colors.pink,
      trimCollapsedText: 'Show more',
      trimExpandedText: 'Show less',
      moreStyle: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
    );
  }
}
