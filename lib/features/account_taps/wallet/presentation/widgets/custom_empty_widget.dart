import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CustomEmptyWidget extends StatelessWidget {
  const CustomEmptyWidget({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 70,
            color: context.isDarkMode ? Colors.white : Colors.grey,
          ),
          Label(
            text: label,
            style: Styles.headerText(
              fontWeight: FontWeight.bold,
              color: context.isDarkMode ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
