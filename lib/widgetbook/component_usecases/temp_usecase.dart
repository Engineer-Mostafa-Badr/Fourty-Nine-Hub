import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/widgetbook/flutter_markdown.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Original example (you can keep or remove this)
// for description
@widgetbook.UseCase(
  name: 'Custom Description',
  type: MarkdownViewer,
)
MarkdownViewer tempDescriptionWidget(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/AppBottomNavBarDoc.md',
  );
}

// for usecase
@widgetbook.UseCase(
  name: 'Custom UseCase',
  type: Type,
)
Widget tempUseCaseWidget(BuildContext context) {
  return const Placeholder();
}
