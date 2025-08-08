import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../core/widget/custom_circular_progress_indicator.dart';
import '../../res/style/app_colors.dart';
import '../utils/flutter_markdown.dart';
import 'text_input_widget_usecases.dart';

@widgetbook.UseCase(
  name: 'CustomCircularProgressIndicator Documentation',
  type: MarkdownViewer,
)
MarkdownViewer customCircularProgressIndicatorDocumentation(
    BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath:
        'assets/markdown/docs/custom_circular_progress_indicator_doc.md',
  );
}

@widgetbook.UseCase(
  name: 'CustomCircularProgressIndicator with Knobs',
  type: CustomCircularProgressIndicator,
)
Widget customCircularProgressIndicatorWidget(BuildContext context) {
  final value = context.knobs.doubleOrNull.slider(
    label: 'Progress Value',
    initialValue: null,
    min: 0.0,
    max: 1.0,
  );

  final strokeWidth = context.knobs.double.slider(
    label: 'Stroke Width',
    initialValue: 4.0,
    min: 1.0,
    max: 10.0,
  );

  final color = context.knobs.listOrNull(
    label: 'Color',
    options: [
      'Primary',
      'Secondary',
      'Red',
      'Green',
      'Blue',
      'Orange',
    ],
    initialOption: 'Primary',
  );

  Color? selectedColor;
  switch (color) {
    case 'Primary':
      selectedColor = AppColors.PRIMARY_COLOR;
      break;
    case 'Secondary':
      selectedColor = AppColors.SECONDARY_COLOR;
      break;
    case 'Red':
      selectedColor = Colors.red;
      break;
    case 'Green':
      selectedColor = Colors.green;
      break;
    case 'Blue':
      selectedColor = Colors.blue;
      break;
    case 'Orange':
      selectedColor = Colors.orange;
      break;
  }

  return WidgetbookScreenUtilFormWrapper(
    child: Scaffold(
      appBar: AppBar(title: const Text('CustomCircularProgressIndicator Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: CustomCircularProgressIndicator(
                  value: value,
                  color: selectedColor,
                  strokeWidth: strokeWidth,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Progress: ${value != null ? (value * 100).toStringAsFixed(1) : 'Indeterminate'}%',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Stroke Width: ${strokeWidth.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ),
  );
}
