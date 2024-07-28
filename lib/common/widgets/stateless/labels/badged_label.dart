import 'package:flutter/material.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import 'label.dart';

class BadgedLabel extends StatelessWidget {
  final Color color, textColor;
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
      this.onTap,
      this.margin,
      this.radius = 10,
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
              color: isBordered ? Colors.white : color,
              border: isBordered ? Border.all(color: color, width: .5) : null,
              borderRadius: BorderRadius.circular(radius)),
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
      style: style ?? Styles.mediumText(color: textColor),
      textAlign: TextAlign.center,
    );
  }
}
