import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CustomNotificationBadge extends StatelessWidget {
  final int count;
  final Widget child;

  const CustomNotificationBadge({
    super.key,
    required this.count,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            top: -9,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFF33D49),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 0.3),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Label(
              text:   FormatNumbers().formatNumber(count, decimals: 0),
                style: Styles.smallText(
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                  color: const Color(0xFFD9D9D9),
                ),
                // const TextStyle(
                //   color: Color(0xFFD9D9D9),
                //   fontSize: 10,
                //   fontWeight: FontWeight.w600,
                // ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}