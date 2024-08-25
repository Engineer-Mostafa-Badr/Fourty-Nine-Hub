import 'package:flutter/material.dart';

void bottomSheet(
    {required BuildContext context,
    required Widget widget,
    Color? backColor ,
    bool isFloating = false,
    bool isScrollControlled = false}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          // margin: const EdgeInsets.all(kToolbarHeight),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: backColor??Theme.of(context).dialogBackgroundColor,
        ),
          child: widget,
        );
      });
}
