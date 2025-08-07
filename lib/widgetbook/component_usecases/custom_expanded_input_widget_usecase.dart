import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../core/widget/custom_expanded_input_widget.dart';
import '../utils/flutter_markdown.dart';
import 'text_input_widget_usecases.dart';

@widgetbook.UseCase(
  name: 'ExpandedInputWidget Documentation',
  type: MarkdownViewer,
)
MarkdownViewer expandedInputWidgetDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/expanded_input_widget_doc.md',
  );
}

@widgetbook.UseCase(
  name: 'ExpandedInputWidget with Knobs',
  type: ExpandedInputWidget,
)
Widget expandedInputWidgetWidget(BuildContext context) {
  final controller = TextEditingController();
  final dropDownItems = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Very Long Item Name That Might Overflow',
    'Item 5'
  ];

  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Select Category',
  );

  final hint = context.knobs.stringOrNull(
    label: 'Hint Text',
    initialValue: 'Choose from options',
  );

  final enabled = context.knobs.boolean(
    label: 'Enabled',
    initialValue: true,
  );

  final isEditAds = context.knobs.boolean(
    label: 'Is Edit Ads',
    initialValue: false,
  );

  final subTitle = context.knobs.stringOrNull(
    label: 'Subtitle',
    initialValue: 'Additional information about this field',
  );

  return WidgetbookScreenUtilFormWrapper(
    child: Scaffold(
      appBar: AppBar(title: const Text('ExpandedInputWidget Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpandedInputWidget(
              title: title,
              controller: controller,
              dropDownList: dropDownItems,
              onSelectItem: (index) {
                print('Selected item at index: $index');
              },
              enabled: enabled,
              isEditAds: isEditAds,
              hint: hint,
              subTitle: subTitle,
              disableMsg: 'This field is currently disabled',
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Widget Status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Enabled: ${enabled ? 'Yes' : 'No'}'),
                    Text('Edit Mode: ${isEditAds ? 'Yes' : 'No'}'),
                    Text('Available Options: ${dropDownItems.length}'),
                    Text(
                        'Current Value: ${controller.text.isEmpty ? 'None' : controller.text}'),
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
