import 'package:flutter/material.dart';


void bottomSheet(
    {required BuildContext context,
    required Widget widget,
    bool isFloating = false,
    bool isScrollControlled = false}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          // margin: const EdgeInsets.all(kToolbarHeight),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.white),
          child: widget,
        );
      });
}
