import 'dart:async';

import 'package:flutter/material.dart';

class MovingWidgetHr extends StatefulWidget {
  final String asset;
  // final String label;
  const MovingWidgetHr({
    super.key,
    required this.asset,
  });

  @override
  State<MovingWidgetHr> createState() => _MovingWidgetHrState();
}

class _MovingWidgetHrState extends State<MovingWidgetHr> {
  double index = 0;
  double rightWidth = 0;
  bool right = true;
  double initWidth = 0;

  @override
  void initState() {
    handleWidth();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initWidth = 100;
    return Container(
      padding: const EdgeInsets.all(5),
      // margin: const EdgeInsets.all(5),
      height: kToolbarHeight * .8,
      width: double.infinity,

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: rightWidth,
          ),
          Transform.flip(
            flipX: right,
            child: Image.asset(
              widget.asset,
              width: 30,
            ),
          ),
          SizedBox(
            width: index,
          ),
        ],
      ),
    );
  }

  void handleWidth() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final width = initWidth;
      if (index < width && right) {
        index++;
        if ((width - index) > -1) {
          rightWidth = width - index;
        }
        if (rightWidth == 1) {
          right = false;
        }
      } else {
        if (index == 1) {
          right = true;
        }
        if ((index - 1) > -1) {
          index--;
        }
        rightWidth++;
      }

      setState(() {});
    });
  }
}
