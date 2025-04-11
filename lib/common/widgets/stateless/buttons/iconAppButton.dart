import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';

class IconAppButton extends StatelessWidget {
  final double? size, height, width, margin, padding, radius;
  final Color? backColor, color;
  final String? label;
  final Function onPressed;
  final Widget? widget;
  final IconData icon;
  final TextStyle? style;
  final bool isCircle;

  const IconAppButton(
      {super.key,
      this.label,
      required this.icon,
      required this.onPressed,
      this.backColor,
      this.height,
      this.radius,
      this.size,
      this.margin,
      this.widget,
      this.padding,
      this.color,
      this.style,
      this.isCircle = false,
      this.width});

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () => onPressed(),
      child: Container(
          alignment: Alignment.center,
          height: height ?? kToolbarHeight * .6,
          width: width,
          margin: EdgeInsets.all(margin ?? 0),
          padding: EdgeInsets.all(padding ?? 0),
          child: _buildWidget()),
    );
  }

  Widget _buildWidget() {
    if (widget != null) {
      return widget!;
    } else if (isCircle) {
      return CircleAvatar(
        radius:radius?? 50.r,
        backgroundColor: backColor,
        child: Icon(
          icon,
          size: size ?? 50.h,
          color: color,
        ),
      );
    } else {
      return Icon(
        icon,
        color: color,
        size: size ?? 45.h,
      );
    }
  }
}
