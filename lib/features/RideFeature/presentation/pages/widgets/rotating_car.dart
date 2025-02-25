import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../res/assets/assets.dart';

class RotatingCar extends StatefulWidget {
  final double size;
  final Duration duration;

  const RotatingCar({
    super.key,
    this.size = 200,
    this.duration = const Duration(seconds: 2),
  });

  @override
  _RotatingCarState createState() => _RotatingCarState();
}

class _RotatingCarState extends State<RotatingCar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double shakeX = sin(_controller.value * 2 * pi) * 2;
            double shakeY = cos(_controller.value * 2 * pi) * 2;

            return Transform.translate(
              offset: Offset(shakeX, shakeY),
              child: Transform.rotate(
                angle: _controller.value * 2 * pi,
                child: child,
              ),
            );
          },
          child: SvgPicture.asset(
            Assets.movingCar2,
            width: widget.size,
            height: widget.size,
          ),
        ),
      ),
    );
  }
}
