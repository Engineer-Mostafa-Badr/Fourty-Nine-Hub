import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../core/widget/icon_and_hint_widget.dart';
import '../utils/flutter_markdown.dart';

@widgetbook.UseCase(
  name: 'IconAndHintWidget Documentation',
  type: MarkdownViewer,
)
MarkdownViewer iconAndHintWidgetDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/icon_and_hint_widget_doc.md',
  );
}

@widgetbook.UseCase(
  name: 'IconAndHintWidget with Knobs',
  type: IconAndHintWidget,
)
Widget iconAndHintWidgetWithKnobs(BuildContext context) {
  final text = context.knobs.string(
    label: 'Text',
    initialValue:
        'This is an important hint or alert message that users should pay attention to.',
    description: 'The text content to display',
  );

  final fontSize = context.knobs.double.slider(
    label: 'Font Size',
    initialValue: 20.0,
    min: 12.0,
    max: 32.0,
    description: 'Font size for the text',
  );

  final maxLines = context.knobs.int.slider(
    label: 'Max Lines',
    initialValue: 2,
    min: 1,
    max: 5,
    description: 'Maximum number of lines for text',
  );

  final fontWeight = context.knobs.list(
    label: 'Font Weight',
    options: [
      'normal',
      'bold',
      'w300',
      'w500',
      'w600',
      'w700',
    ],
    initialOption: 'normal',
  );

  final textColor = context.knobs.listOrNull(
    label: 'Text Color',
    options: ['Auto (Theme)', 'Black', 'White', 'Red', 'Blue', 'Orange'],
    initialOption: 'Auto (Theme)',
  );

  final isDarkTheme = context.knobs.boolean(
    label: 'Dark Theme',
    initialValue: false,
    description: 'Toggle theme to test auto color behavior',
  );

  final showCustomIcon = context.knobs.boolean(
    label: 'Show Custom Icon',
    initialValue: false,
    description: 'Use custom icon instead of default alert icon',
  );

  final customIcon = context.knobs.list(
    label: 'Custom Icon',
    options: [
      'info',
      'warning',
      'error',
      'check_circle',
      'lightbulb',
      'help',
    ],
    initialOption: 'info',
  );

  FontWeight getFontWeight() {
    switch (fontWeight) {
      case 'bold':
        return FontWeight.bold;
      case 'w300':
        return FontWeight.w300;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      default:
        return FontWeight.normal;
    }
  }

  Color? getTextColor(BuildContext context) {
    switch (textColor) {
      case 'Black':
        return Colors.black;
      case 'White':
        return Colors.white;
      case 'Red':
        return Colors.red;
      case 'Blue':
        return Colors.blue;
      case 'Orange':
        return Colors.orange;
      default:
        return isDarkTheme ? Colors.white : Colors.black;
    }
  }

  IconData getCustomIcon() {
    switch (customIcon) {
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'check_circle':
        return Icons.check_circle;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'help':
        return Icons.help;
      default:
        return Icons.info;
    }
  }

  Widget buildCustomWidget() {
    return Row(
      children: [
        Icon(
          getCustomIcon(),
          color: getTextColor(context),
          size: 24,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: getFontWeight(),
              color: getTextColor(context),
            ),
          ),
        ),
      ],
    );
  }

  return Theme(
    data: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
    child: Scaffold(
      backgroundColor: isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white,
      appBar: AppBar(
        title: const Text('IconAndHintWidget Demo'),
        backgroundColor: isDarkTheme ? Colors.grey[850] : Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main widget demo
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showCustomIcon
                          ? 'Custom Icon Version'
                          : 'Original IconAndHintWidget',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    showCustomIcon
                        ? buildCustomWidget()
                        : IconAndHintWidget(
                            text: text,
                            textStyle: TextStyle(
                              fontSize: fontSize,
                              fontWeight: getFontWeight(),
                              color: getTextColor(context),
                            ),
                          ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Configuration info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Configuration',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text('Font Size: ${fontSize.toStringAsFixed(1)}px'),
                    Text('Max Lines: $maxLines'),
                    Text('Font Weight: $fontWeight'),
                    Text('Text Color: $textColor'),
                    Text('Theme: ${isDarkTheme ? 'Dark' : 'Light'}'),
                    if (showCustomIcon) Text('Custom Icon: $customIcon'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Usage examples
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Common Use Cases',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    IconAndHintWidget(
                      text: 'Warning: Please verify your email address',
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    IconAndHintWidget(
                      text: 'Information: Your data is automatically saved',
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    IconAndHintWidget(
                      text:
                          'Important: Complete all required fields before submitting',
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.red[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Feature info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Widget Features:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• SVG alert icon from assets'),
                  Text('• Expandable text with line limits'),
                  Text('• Theme-aware text colors'),
                  Text('• Customizable text styling'),
                  Text('• Responsive layout with Row + Expanded'),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'IconAndHintWidget Variations',
  type: IconAndHintWidget,
)
Widget iconAndHintWidgetVariations(BuildContext context) {
  final messageType = context.knobs.list(
    label: 'Message Type',
    options: ['Info', 'Warning', 'Error', 'Success', 'Tip'],
    initialOption: 'Info',
  );

  final messageLength = context.knobs.list(
    label: 'Message Length',
    options: ['Short', 'Medium', 'Long', 'Very Long'],
    initialOption: 'Medium',
  );

  final isDarkTheme = context.knobs.boolean(
    label: 'Dark Theme',
    initialValue: false,
  );

  Map<String, Map<String, dynamic>> getMessageConfig() {
    return {
      'Info': {
        'color': Colors.blue[700],
        'icon': Icons.info_outline,
        'short': 'Information available',
        'medium': 'This is an informational message for users',
        'long':
            'This is a detailed informational message that provides users with important context about the current state or action',
        'very_long':
            'This is a very detailed informational message that provides users with comprehensive context about the current state, available actions, and potential next steps they should consider taking',
      },
      'Warning': {
        'color': Colors.orange[700],
        'icon': Icons.warning_outlined,
        'short': 'Warning: Action required',
        'medium': 'Warning: Please review your settings before proceeding',
        'long':
            'Warning: Some settings may affect your user experience. Please review all configurations before saving changes',
        'very_long':
            'Warning: The changes you are about to make may significantly impact your user experience and data processing. Please carefully review all configurations and consider the implications before proceeding with these modifications',
      },
      'Error': {
        'color': Colors.red[700],
        'icon': Icons.error_outline,
        'short': 'Error occurred',
        'medium': 'Error: Unable to process your request at this time',
        'long':
            'Error: We encountered an issue processing your request. Please check your input and try again',
        'very_long':
            'Error: We encountered a technical issue while processing your request. This may be due to network connectivity, server problems, or invalid input data. Please verify your information and try again, or contact support if the problem persists',
      },
      'Success': {
        'color': Colors.green[700],
        'icon': Icons.check_circle_outline,
        'short': 'Success!',
        'medium': 'Success: Your changes have been saved successfully',
        'long':
            'Success: Your profile has been updated and all changes have been saved to your account',
        'very_long':
            'Success: Your profile information has been successfully updated and synchronized across all connected devices. All changes have been saved to your account and are now active. You may need to refresh the page to see some changes take effect',
      },
      'Tip': {
        'color': Colors.purple[700],
        'icon': Icons.lightbulb_outline,
        'short': 'Pro tip available',
        'medium': 'Tip: Use keyboard shortcuts to work more efficiently',
        'long':
            'Tip: You can use keyboard shortcuts and quick actions to significantly improve your workflow efficiency',
        'very_long':
            'Pro Tip: To maximize your productivity, take advantage of our advanced keyboard shortcuts, batch operations, and automation features. These tools can help you complete tasks up to 50% faster and reduce repetitive work significantly',
      },
    };
  }

  String getMessageText() {
    final config = getMessageConfig()[messageType]!;
    switch (messageLength.toLowerCase()) {
      case 'short':
        return config['short'];
      case 'long':
        return config['long'];
      case 'very long':
        return config['very_long'];
      default:
        return config['medium'];
    }
  }

  Color getMessageColor() {
    return getMessageConfig()[messageType]!['color'];
  }

  IconData getMessageIcon() {
    return getMessageConfig()[messageType]!['icon'];
  }

  Widget buildIconRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  return Theme(
    data: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
    child: Scaffold(
      appBar: AppBar(title: const Text('IconAndHintWidget Variations')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Current selection
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$messageType Message ($messageLength)',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    buildIconRow(
                      getMessageIcon(),
                      getMessageText(),
                      getMessageColor(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // All message types showcase
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'All Message Types:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),

                  // Info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: buildIconRow(
                        Icons.info_outline,
                        'Information: This is an informational message',
                        Colors.blue[700]!,
                      ),
                    ),
                  ),

                  // Warning
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: buildIconRow(
                        Icons.warning_outlined,
                        'Warning: Please review before proceeding',
                        Colors.orange[700]!,
                      ),
                    ),
                  ),

                  // Error
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: buildIconRow(
                        Icons.error_outline,
                        'Error: Unable to complete the requested action',
                        Colors.red[700]!,
                      ),
                    ),
                  ),

                  // Success
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: buildIconRow(
                        Icons.check_circle_outline,
                        'Success: Operation completed successfully',
                        Colors.green[700]!,
                      ),
                    ),
                  ),

                  // Tip
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: buildIconRow(
                        Icons.lightbulb_outline,
                        'Tip: Use shortcuts to improve your workflow',
                        Colors.purple[700]!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'IconAndHintWidget Layout Demo',
  type: IconAndHintWidget,
)
Widget iconAndHintWidgetLayoutDemo(BuildContext context) {
  final containerWidth = context.knobs.double.slider(
    label: 'Container Width',
    initialValue: 300.0,
    min: 150.0,
    max: 500.0,
  );

  final padding = context.knobs.double.slider(
    label: 'Container Padding',
    initialValue: 16.0,
    min: 8.0,
    max: 32.0,
  );

  final backgroundColor = context.knobs.listOrNull(
    label: 'Background Color',
    options: ['None', 'Light Blue', 'Light Yellow', 'Light Red', 'Light Green'],
    initialOption: 'Light Blue',
  );

  Color? getBackgroundColor() {
    switch (backgroundColor) {
      case 'Light Blue':
        return Colors.blue.withOpacity(0.1);
      case 'Light Yellow':
        return Colors.yellow.withOpacity(0.1);
      case 'Light Red':
        return Colors.red.withOpacity(0.1);
      case 'Light Green':
        return Colors.green.withOpacity(0.1);
      default:
        return null;
    }
  }

  return Scaffold(
    appBar: AppBar(title: const Text('IconAndHintWidget Layout')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Constrained width demo
          Container(
            width: containerWidth,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: getBackgroundColor(),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const IconAndHintWidget(
              text:
                  'This text will wrap and adapt to the container width. Notice how the icon stays aligned at the top.',
            ),
          ),

          const SizedBox(height: 32),

          // Configuration info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Layout Properties:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Container Width: ${containerWidth.toInt()}px'),
                  Text('Padding: ${padding.toInt()}px'),
                  Text('Background: ${backgroundColor ?? 'None'}'),
                  const SizedBox(height: 12),
                  const Text(
                    'The widget uses Row with Expanded to ensure text wraps properly while keeping the icon aligned.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
