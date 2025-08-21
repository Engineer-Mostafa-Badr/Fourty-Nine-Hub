import 'package:flutter/material.dart';

class ClickableWidget extends StatelessWidget {
  const ClickableWidget({super.key, this.onTap,this.onLongPress, required this.child});
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }
}