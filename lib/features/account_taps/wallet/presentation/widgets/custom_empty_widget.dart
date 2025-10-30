import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CustomEmptyWidget extends StatelessWidget {
  const CustomEmptyWidget({
    super.key,
    required this.label,
    this.icon,
    this.context,
  });

  const CustomEmptyWidget.searchInitial({
    super.key,
    required BuildContext context,
  })  : label = null,
        icon = Icons.search,
        context = context;

  final String? label;
  final IconData? icon;
  final BuildContext? context;

  @override
  Widget build(BuildContext context) {
    final displayLabel = label ??
        (context.isArabic ?? context.isArabic
            ? 'ابدأ الكتابة للبحث'
            : 'Start typing to search');

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.warning_amber_rounded,
            size: 70,
            color: context.isDarkMode ? Colors.white : Colors.grey,
          ),
          Label(
            text: displayLabel,
            style: Styles.headerText(
              fontWeight: FontWeight.bold,
              color: context.isDarkMode ? Colors.white : Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              label,
              style: Styles.headerText(
                fontWeight: FontWeight.bold,
                color: context.isDarkMode ? Colors.white : Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: null,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
