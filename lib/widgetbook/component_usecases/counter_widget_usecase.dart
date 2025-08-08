import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../core/widget/counter_widget.dart';
import '../utils/flutter_markdown.dart';
import 'text_input_widget_usecases.dart';

@widgetbook.UseCase(
  name: 'CounterWidget Documentation',
  type: MarkdownViewer,
)
MarkdownViewer counterWidgetDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/counter_widget_doc.md',
  );
}

@widgetbook.UseCase(
  name: 'CounterWidget States',
  type: CounterWidget,
)
Widget counterWidgetStatesWidget(BuildContext context) {
  return WidgetbookScreenUtilFormWrapper(
    child: Scaffold(
      appBar: AppBar(title: const Text('CounterWidget - Different States')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Number Formatting Examples',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            // Single digits
            _buildCounterSection(
              title: 'Single Digits',
              counters: [
                CounterWidget(unreadCount: 1),
                CounterWidget(unreadCount: 5),
                CounterWidget(unreadCount: 9),
              ],
              labels: ['1', '5', '9'],
            ),

            // Double digits
            _buildCounterSection(
              title: 'Double Digits',
              counters: [
                CounterWidget(unreadCount: 10),
                CounterWidget(unreadCount: 42),
                CounterWidget(unreadCount: 99),
              ],
              labels: ['10', '42', '99'],
            ),

            // Thousands
            _buildCounterSection(
              title: 'Thousands (K)',
              counters: [
                CounterWidget(unreadCount: 1000),
                CounterWidget(unreadCount: 5500),
                CounterWidget(unreadCount: 999000),
              ],
              labels: ['1K', '5.5K', '999K'],
            ),

            // Millions
            _buildCounterSection(
              title: 'Millions (M)',
              counters: [
                CounterWidget(unreadCount: 1000000),
                CounterWidget(unreadCount: 2500000),
                CounterWidget(unreadCount: 999000000),
              ],
              labels: ['1M', '2.5M', '999M'],
            ),

            // Billions
            _buildCounterSection(
              title: 'Billions (B)',
              counters: [
                CounterWidget(unreadCount: 1000000000),
                CounterWidget(unreadCount: 1500000000),
              ],
              labels: ['1B', '1.5B'],
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'CounterWidget with Knobs',
  type: CounterWidget,
)
Widget counterWidgetWidget(BuildContext context) {
  final unreadCount = context.knobs.int.slider(
    label: 'Unread Count',
    initialValue: 5,
    min: 0,
    max: 999999,
  );

  final width = context.knobs.doubleOrNull.slider(
    label: 'Width',
    initialValue: 38.0,
    min: 20.0,
    max: 80.0,
  );

  final height = context.knobs.doubleOrNull.slider(
    label: 'Height',
    initialValue: 38.0,
    min: 20.0,
    max: 80.0,
  );

  final fontSize = context.knobs.doubleOrNull.slider(
    label: 'Font Size',
    initialValue: 12.0,
    min: 8.0,
    max: 24.0,
  );

  final borderWidth = context.knobs.doubleOrNull.slider(
    label: 'Border Width',
    initialValue: 1.0,
    min: 0.0,
    max: 5.0,
  );

  final bgColor = context.knobs.listOrNull(
    label: 'Background Color',
    options: ['Red', 'Green', 'Blue', 'Orange', 'Purple'],
    initialOption: 'Red',
  );

  Color? backgroundColor;
  switch (bgColor) {
    case 'Red':
      backgroundColor = Colors.red;
      break;
    case 'Green':
      backgroundColor = Colors.green;
      break;
    case 'Blue':
      backgroundColor = Colors.blue;
      break;
    case 'Orange':
      backgroundColor = Colors.orange;
      break;
    case 'Purple':
      backgroundColor = Colors.purple;
      break;
  }

  return WidgetbookScreenUtilFormWrapper(
    child: Scaffold(
      appBar: AppBar(title: const Text('CounterWidget Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: CounterWidget(
                  unreadCount: unreadCount,
                  width: width,
                  height: height,
                  fontSize: fontSize,
                  borderWidth: borderWidth,
                  bgColor: backgroundColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Count: $unreadCount',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            // Different counter examples
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    CounterWidget(unreadCount: 1),
                    const SizedBox(height: 8),
                    const Text('Small'),
                  ],
                ),
                Column(
                  children: [
                    CounterWidget(unreadCount: 99),
                    const SizedBox(height: 8),
                    const Text('Medium'),
                  ],
                ),
                Column(
                  children: [
                    CounterWidget(unreadCount: 1500),
                    const SizedBox(height: 8),
                    const Text('Large (1.5K)'),
                  ],
                ),
                Column(
                  children: [
                    CounterWidget(unreadCount: 1000000),
                    const SizedBox(height: 8),
                    const Text('Million (1M)'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildCounterSection({
  required String title,
  required List<CounterWidget> counters,
  required List<String> labels,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          counters.length,
          (index) => Column(
            children: [
              counters[index],
              const SizedBox(height: 4),
              Text(
                labels[index],
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}
