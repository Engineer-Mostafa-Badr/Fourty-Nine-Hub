import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ButtonSubscription extends StatelessWidget {
  const ButtonSubscription({super.key, required this.cancelColor});

  final bool cancelColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // width: 160,
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        decoration: ShapeDecoration(
          color:
              cancelColor ? const Color(0xFFF33D49) : const Color(0xFF0B1035),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Center(
          child: Label(
            text: cancelColor ? 'Cancel' : 'Renewal',
            style: Styles.headerText(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
