import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';

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
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
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
        child: Icon(
          icon,
          size: size ?? 30,
        ),
      );
    } else {
      return Icon(
        icon,
        color: color,
        size: size ?? 45.zH,
      );
    }
  }
}
