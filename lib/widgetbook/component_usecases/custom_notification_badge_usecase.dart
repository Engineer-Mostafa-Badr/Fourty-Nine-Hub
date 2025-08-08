import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/widget/custom_notification_badge.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../utils/flutter_markdown.dart'; // If you have a MarkdownViewer widget

// Documentation Use Case
@widgetbook.UseCase(
  name: 'CustomNotificationBadge Documentation',
  type: MarkdownViewer,
)
MarkdownViewer customNotificationBadgeDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/custom_notification_badge_doc.md',
  );
}

// Interactive Use Case with Knobs
@widgetbook.UseCase(
  name: 'CustomNotificationBadge with Knobs',
  type: CustomNotificationBadge,
)
Widget customNotificationBadgeWithKnobs(BuildContext context) {
  final count = context.knobs.int.slider(
    label: 'Notification Count',
    initialValue: 5,
    min: 0,
    max: 100,
    divisions: 100,
    description: 'Number displayed in the badge (0 hides the badge).',
  );

  final childIcon = context.knobs.list<IconData>(
    label: 'Child Icon',
    options: [
      Icons.notifications,
      Icons.message,
      Icons.favorite,
      Icons.shopping_cart,
    ],
    labelBuilder: (value) => value.toString(),
    initialOption: Icons.notifications,
  );

  final iconSize = context.knobs.double.slider(
    label: 'Child Icon Size',
    initialValue: 24.0,
    min: 16.0,
    max: 48.0,
    divisions: 32,
    description: 'Size of the child icon.',
  );

  final badgeColor = context.knobs.color(
    label: 'Badge Color',
    initialValue: const Color(0xFFF33D49),
    description: 'Background color of the notification badge.',
  );

  final textColor = context.knobs.color(
    label: 'Text Color',
    initialValue: const Color(0xFFD9D9D9),
    description: 'Color of the badge text.',
  );

  final isDarkTheme = context.knobs.boolean(
    label: 'Dark Theme',
    initialValue: false,
    description: 'Toggle between light and dark theme.',
  );

  return WidgetbookScreenUtilFormWrapper(
    child: Theme(
      data: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(title: const Text('CustomNotificationBadge Demo')),
        body: Center(
          child: CustomNotificationBadge(
            count: count,
            child: Icon(
              childIcon,
              size: iconSize,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    ),
  );
}

// Wrapper for Widgetbook
class WidgetbookScreenUtilFormWrapper extends StatelessWidget {
  final Widget child;

  const WidgetbookScreenUtilFormWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: child,
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          bodyMedium: Styles.smallText(
            fontWeight: FontWeight.w600,
            fontSize: 19,
            color: const Color(0xFFD9D9D9),
          ),
        ),
      ),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}
