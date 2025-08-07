import 'package:flutter/widgets.dart';
import '../utils/flutter_markdown.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Installation Documentation
@widgetbook.UseCase(
  name: '02 Installation.docs',
  type: MarkdownViewer,
)
MarkdownViewer installationWidget(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/Installation.md',
  );
}

// Introduction Documentation
@widgetbook.UseCase(
  name: '01 Introduction.docs',
  type: MarkdownViewer,
)
MarkdownViewer introductionWidget(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/Introduction.md',
  );
}

// Migration and Updates Documentation
@widgetbook.UseCase(
  name: '04 Migration and Updates.docs',
  type: MarkdownViewer,
)
MarkdownViewer migrationAndUpdatesWidget(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/MigrationAndUpdates.md',
  );
}

// Usage Documentation
@widgetbook.UseCase(
  name: '03 Usage.docs',
  type: MarkdownViewer,
)
MarkdownViewer usageWidget(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/Usage.md',
  );
}
