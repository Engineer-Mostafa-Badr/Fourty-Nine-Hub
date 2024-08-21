import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import 'label.dart';

class BadgedLabel extends StatelessWidget {
  final Color color, textColor, borderColor;
  final String label;
  final double radius;
  final TextStyle? style;
  final double? height, width, margin;
  final Function? onTap;
  final bool isBordered;
  final bool isCentered;

   const BadgedLabel(
      {super.key,
      this.color = AppColors.PRIMARY_COLOR,
      required this.label,
      this.height,
      this.width,
      this.style,
      this.borderColor = AppColors.PRIMARY_COLOR,
      this.onTap,
      this.margin,
      this.radius = 20,
      this.isBordered = false,
      this.isCentered = false,
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
          height: height,
          width: width,
          margin: EdgeInsets.all(margin ?? 0),
          padding:  EdgeInsets.symmetric(horizontal: 20.zW, vertical: 6.zH),
          decoration: BoxDecoration(
              color: isBordered ? color : color,
              border:
                  isBordered ? Border.all(color: borderColor, width: .5.zW) : null,
              borderRadius: BorderRadius.circular(radius.zR)),
          child: isCentered
              ? Center(
                  child: _buildLabelWidget(),
                )
              : _buildLabelWidget()),
    );
  }

  Widget _buildLabelWidget() {
    return Label(
      text: label,
      style: Styles.mediumText(color: textColor),
      textAlign: TextAlign.center,
    );
  }
}
