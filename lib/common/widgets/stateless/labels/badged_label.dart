import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import 'label.dart';

class BadgedLabel extends StatelessWidget {
  final Color color, textColor, borderColor;
  final String label;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final TextOverflow? overFlow;
  final int? max;
  final TextStyle? style;
  final double? height, width, margin;
  final Function? onTap;
  final IconData? icon;
  final IconData? iconLeading;
  final bool isBordered;
  final bool isCentered;
  final bool close;
  final MainAxisAlignment? mainAxisAlignment;
  final bool? hasHighlightColor;
  final bool? hasSplashColor;

  final GestureTapCallback? onRemove;

  const BadgedLabel(
      {super.key,
      this.color = AppColors.PRIMARY_COLOR,
      required this.label,
      this.height,
      this.width,
      this.style,
      this.padding,
      this.borderColor = AppColors.PRIMARY_COLOR,
      this.onTap,
      this.onRemove,
      this.margin,
      this.radius = 20,
      this.isBordered = false,
      this.isCentered = false,
      this.close = true,
      this.textColor = Colors.white,
      this.icon,
      this.iconLeading,
      this.overFlow,
      this.max,
      this.mainAxisAlignment,
      this.hasHighlightColor,
      this.hasSplashColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor:
            hasSplashColor! ? Colors.transparent : Colors.grey.shade200,
        highlightColor:
            hasHighlightColor! ? Colors.transparent : Colors.grey.shade200,
        onTap: () {
          ManageVibration.vibrate();
          if (onTap != null) {
            onTap!();
          }
        },
        child: Container(
            height: height,
            width: width,
            margin: EdgeInsets.all(margin ?? 0),
            padding: padding ??
                EdgeInsets.symmetric(horizontal: 20.w.w, vertical: 6.h.h),
            //padding: EdgeInsetsDirectional.only(end: 8,top: 5),
            decoration: BoxDecoration(
                color: isBordered ? color : color,
                border: isBordered ? Border.all(color: borderColor) : null,
                borderRadius: BorderRadius.circular(radius)),
            // child: isCentered
            //     ? Center(
            //         child: _buildLabelWidget(),
            //       )
            //     : _buildLabelWidget()),
            //         customBorder: isBordered ? Border.all(color: borderColor, width: .5) : null,
            //     borderRadius: BorderRadius.circular(radius),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 10.w.w, vertical: 3.h.w),
              child: isCentered
                  ? Center(
                      child: _buildLabelWidget(),
                    )
                  : _buildLabelWidget(),
            )));
  }

  Widget _buildLabelWidget() {
    return Row(
      mainAxisAlignment: mainAxisAlignment != null
          ? mainAxisAlignment!
          : (icon != null && iconLeading != null)
              ? MainAxisAlignment.spaceBetween
              : (icon != null || iconLeading != null)
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
      children: [
        if (icon != null)
          Icon(
            icon,
            color: textColor,
            size: 35.sp,
          ),
        Label(
          text: label,
          style: style ?? Styles.mediumText(color: textColor),
          textAlign: TextAlign.center,
          overflow: overFlow,
          maxLines: max,
        ),
        if (iconLeading != null)
          Icon(
            iconLeading,
            color: textColor,
            size: 35.sp,
          ),
      ],
    );
  }
}
