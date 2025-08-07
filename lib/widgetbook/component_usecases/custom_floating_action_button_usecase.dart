import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/widget/custom_floating_action_button.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../utils/flutter_markdown.dart';

// Documentation Use Case
@widgetbook.UseCase(
  name: 'CustomFloatingActionButton Documentation',
  type: MarkdownViewer,
)
MarkdownViewer customFloatingActionButtonDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath:
        'assets/markdown/docs/custom_floating_action_button_doc.md',
  );
}

// Interactive Use Case with Knobs
@widgetbook.UseCase(
  name: 'CustomFloatingActionButton with Knobs',
  type: CustomFloatingActionButton,
)
Widget customFloatingActionButtonWithKnobs(BuildContext context) {
  final icon = context.knobs.list<IconData?>(
    label: 'Icon',
    options: [
      null,
      Icons.add,
      Icons.edit,
      Icons.delete,
      Icons.check,
    ],
    labelBuilder: (value) => value == null ? 'None' : value.toString(),
    initialOption: Icons.add,
  );

  final text = context.knobs.stringOrNull(
    label: 'Button Text',
    initialValue: 'Action',
  );

  final fontSize = context.knobs.double.slider(
    label: 'Font Size',
    initialValue: 16.0,
    min: 12.0,
    max: 24.0,
    divisions: 12,
  );

  final iconSize = context.knobs.double.slider(
    label: 'Icon Size',
    initialValue: 24.0,
    min: 16.0,
    max: 32.0,
    divisions: 16,
  );

  final isDarkTheme = context.knobs.boolean(
    label: 'Dark Theme',
    initialValue: false,
  );

  return WidgetbookScreenUtilFormWrapper(
    child: Theme(
      data: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(title: const Text('CustomFloatingActionButton Demo')),
        body: Center(
          child: CustomFloatingActionButton(
            onPressed: () {
              print('Button pressed!');
            },
            icon: icon,
            text: text,
            fontSize: fontSize,
            iconSize: iconSize,
          ),
        ),
        floatingActionButton: null, // Ensure no default FAB interferes
      ),
    ),
  );
}

// Wrapper for Widgetbook (adjust based on your project setup)
class WidgetbookScreenUtilFormWrapper extends StatelessWidget {
  final Widget child;

  const WidgetbookScreenUtilFormWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: child,
      theme: ThemeData.light(), // Adjust theme as needed
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}
