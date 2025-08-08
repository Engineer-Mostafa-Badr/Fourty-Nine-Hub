import 'package:flutter/material.dart';
import 'package:fourtyninehub/widgetbook/component_usecases/text_input_widget_usecases.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../core/widget/clickable_widget.dart'; // Adjust path as needed
import '../utils/flutter_markdown.dart';

@widgetbook.UseCase(
  name: 'ClickableWidget Documentation',
  type: MarkdownViewer,
)
MarkdownViewer clickableWidgetDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/clickable_widget_doc.md',
  );
}

@widgetbook.UseCase(
  name: 'ClickableWidget with Knobs',
  type: ClickableWidget,
)
Widget clickableWidgetWidget(BuildContext context) {
  final childType = context.knobs.list(
    label: 'Child Widget Type',
    options: ['Container', 'Text', 'Icon', 'Card', 'ListTile'],
    initialOption: 'Container',
  );

  final containerWidth = context.knobs.double.slider(
    label: 'Container Width',
    initialValue: 150,
    min: 50,
    max: 300,
  );

  final containerHeight = context.knobs.double.slider(
    label: 'Container Height',
    initialValue: 100,
    min: 50,
    max: 200,
  );

  final backgroundColor = context.knobs.list(
    label: 'Background Color',
    options: ['blue', 'red', 'green', 'purple', 'orange', 'transparent'],
    initialOption: 'blue',
  );

  final text = context.knobs.string(
    label: 'Text Content',
    initialValue: 'Click Me!',
  );

  final fontSize = context.knobs.double.slider(
    label: 'Font Size',
    initialValue: 16,
    min: 12,
    max: 32,
  );

  final borderRadius = context.knobs.double.slider(
    label: 'Border Radius',
    initialValue: 8,
    min: 0,
    max: 50,
  );

  final showFeedback = context.knobs.boolean(
    label: 'Show Tap Feedback',
    initialValue: true,
  );

  int tapCount = 0;
  String lastTappedTime = 'Never';

  Color getColor(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      case 'transparent':
        return Colors.transparent;
      default:
        return Colors.blue;
    }
  }

  Widget getChildWidget() {
    switch (childType) {
      case 'Text':
        return Container(
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            color: getColor(backgroundColor),
            borderRadius: BorderRadius.circular(borderRadius),
            border: backgroundColor == 'transparent'
                ? Border.all(color: Colors.grey, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: backgroundColor == 'transparent' ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      case 'Icon':
        return Container(
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            color: getColor(backgroundColor),
            borderRadius: BorderRadius.circular(borderRadius),
            border: backgroundColor == 'transparent'
                ? Border.all(color: Colors.grey, width: 2)
                : null,
          ),
          child: Icon(
            Icons.touch_app,
            size: fontSize * 2,
            color: backgroundColor == 'transparent' ? Colors.black : Colors.white,
          ),
        );
      case 'Card':
        return SizedBox(
          width: containerWidth,
          height: containerHeight,
          child: Card(
            color: getColor(backgroundColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: backgroundColor == 'transparent' ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      case 'ListTile':
        return Container(
          width: containerWidth,
          decoration: BoxDecoration(
            color: getColor(backgroundColor),
            borderRadius: BorderRadius.circular(borderRadius),
            border: backgroundColor == 'transparent'
                ? Border.all(color: Colors.grey, width: 2)
                : null,
          ),
          child: ListTile(
            leading: Icon(
              Icons.touch_app,
              color: backgroundColor == 'transparent' ? Colors.black : Colors.white,
            ),
            title: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: backgroundColor == 'transparent' ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Tap to interact',
              style: TextStyle(
                color: backgroundColor == 'transparent' 
                    ? Colors.grey[600] 
                    : Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        );
      default: // Container
        return Container(
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            color: getColor(backgroundColor),
            borderRadius: BorderRadius.circular(borderRadius),
            border: backgroundColor == 'transparent'
                ? Border.all(color: Colors.grey, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: backgroundColor == 'transparent' ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
    }
  }

  return WidgetbookScreenUtilFormWrapper(
    child: Scaffold(
      appBar: AppBar(title: const Text('ClickableWidget Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Tap the widget below to test interaction',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 30),
            Center(
              child: ClickableWidget(
                onTap: showFeedback
                    ? () {
                        tapCount++;
                        lastTappedTime = DateTime.now().toString().substring(11, 19);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tapped! Count: $tapCount'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    : null,
                child: getChildWidget(),
              ),
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
                    Text('Child Type: $childType'),
                    Text('Dimensions: ${containerWidth.toInt()}x${containerHeight.toInt()}'),
                    Text('Background: $backgroundColor'),
                    Text('Border Radius: ${borderRadius.toInt()}px'),
                    Text('Tap Feedback: ${showFeedback ? 'Enabled' : 'Disabled'}'),
                    Text('Tap Count: $tapCount'),
                    Text('Last Tapped: $lastTappedTime'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Widget Features',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('• Transparent splash, highlight, and hover effects'),
                    const Text('• Customizable onTap callback'),
                    const Text('• Wraps any child widget'),
                    const Text('• Maintains child widget appearance'),
                    const Text('• Optional tap handling (can be null)'),
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

@widgetbook.UseCase(
  name: 'ClickableWidget Examples',
  type: ClickableWidget,
)
Widget clickableWidgetExamples(BuildContext context) {
  return WidgetbookScreenUtilFormWrapper(
    child: Scaffold(
      appBar: AppBar(title: const Text('ClickableWidget Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Different Use Cases',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            
            // Example 1: Simple Button-like
            Text('1. Simple Button-like Widget:'),
            const SizedBox(height: 8),
            ClickableWidget(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Button clicked!')),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Custom Button',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Example 2: Card-like clickable area
            Text('2. Clickable Card:'),
            const SizedBox(height: 8),
            ClickableWidget(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Card clicked!')),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Clickable Card', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Tap anywhere on this card'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Example 3: Disabled state
            Text('3. Disabled State (onTap: null):'),
            const SizedBox(height: 8),
            ClickableWidget(
              onTap: null, // Disabled
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Disabled Button',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}