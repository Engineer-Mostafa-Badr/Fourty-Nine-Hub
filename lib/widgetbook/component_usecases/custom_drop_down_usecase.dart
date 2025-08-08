import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../core/widget/custom_drop_down.dart';
import '../utils/flutter_markdown.dart';
import 'text_input_widget_usecases.dart';

@widgetbook.UseCase(
  name: 'CustomDropDown Documentation',
  type: MarkdownViewer,
)
MarkdownViewer customDropDownDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/custom_drop_down_doc.md',
  );
}

@widgetbook.UseCase(
  name: 'CustomDropDown with Knobs',
  type: CustomDropDown,
)
Widget customDropDownWidget(BuildContext context) {
  final items = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Long Option Name'
  ];
  String? selectedValue;

  final hint = context.knobs.string(
    label: 'Hint Text',
    initialValue: 'Select an option',
  );

  final height = context.knobs.doubleOrNull.slider(
    label: 'Height',
    initialValue: 42.0,
    min: 30.0,
    max: 80.0,
  );

  final verticalPadding = context.knobs.doubleOrNull.slider(
    label: 'Vertical Padding',
    initialValue: 8.0,
    min: 4.0,
    max: 20.0,
  );

  final hasTranslation = context.knobs.boolean(
    label: 'Has Translation',
    initialValue: false,
  );

  return WidgetbookScreenUtilFormWrapper(
    child: Scaffold(
      appBar: AppBar(title: const Text('CustomDropDown Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CustomDropDown Example',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            CustomDropDown(
              list: items,
              hint: hint,
              value: selectedValue,
              height: height,
              verticalPadding: verticalPadding,
              hasTranslation: hasTranslation,
              onSelect: (value) {
                selectedValue = value;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select an option';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuration',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Height: ${height?.toStringAsFixed(1) ?? 'Default'}'),
                    Text(
                        'Vertical Padding: ${verticalPadding?.toStringAsFixed(1) ?? 'Default'}'),
                    Text('Has Translation: ${hasTranslation ? 'Yes' : 'No'}'),
                    Text('Available Options: ${items.length}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
