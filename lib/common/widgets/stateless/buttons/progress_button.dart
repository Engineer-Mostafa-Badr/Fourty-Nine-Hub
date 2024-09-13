import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../dynamic/sizer.dart';
import '../labels/label.dart';

class ProgressButton extends StatefulWidget {
  final double? height, margin, padding, radius, width, iconSize;
  final Color? backColor, textColor;
  final double maxTimeInSeconds;
  final String label;
  final Function onPressed;
  final Widget? widget;
  final TextStyle? style;
  final IconData? icon;

  const ProgressButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.backColor,
      this.maxTimeInSeconds = 10,
      this.height,
      this.radius,
      this.margin,
      this.widget,
      this.padding,
      this.iconSize,
      this.textColor,
      this.style,
      this.icon,
      this.width});

  @override
  State<ProgressButton> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  late double value;

  @override
  void initState() {
    value = widget.maxTimeInSeconds;
    handleProgress();
    super.initState();
  }

  void handleProgress() async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (value > 0) {
        value--;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value > 0) {
          widget.onPressed();
        }
      },
      child: Container(
        height: widget.height ?? kToolbarHeight * .6,
        width: widget.width,
        margin: EdgeInsets.all(widget.margin ?? 0),
        padding: EdgeInsets.symmetric(horizontal: widget.padding ?? 0),
        child: Stack(
          children: [
            Positioned.fill(
                child: LinearProgressIndicator(
              minHeight: widget.height ?? kToolbarHeight * .6,
              value: value / widget.maxTimeInSeconds,
              color: AppColors.SECONDARY_COLOR,
            )),
            Positioned.fill(
              child: widget.widget ??
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null)
                          Icon(
                            widget.icon,
                            size: widget.iconSize ?? 16,
                            color: widget.textColor ?? Colors.white,
                          ),
                        if (widget.icon != null)  Sizer(),
                        Label(
                            text: widget.label,
                            style: widget.style ??
                                Styles.mediumText(
                                    color: widget.textColor ?? Colors.white)),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
