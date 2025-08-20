import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/widget/custom_switch_button.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../utils/flutter_markdown.dart'; // If you have a MarkdownViewer widget

// Documentation Use Case
@widgetbook.UseCase(
  name: 'CustomSwitchButton Documentation',
  type: MarkdownViewer,
)
MarkdownViewer customSwitchButtonDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/custom_switch_button_doc.md',
  );
}

// Interactive Use Case with Knobs
@widgetbook.UseCase(
  name: 'CustomSwitchButton with Knobs',
  type: CustomSwitchButton,
)
Widget customSwitchButtonWithKnobs(BuildContext context) {
  final value = context.knobs.boolean(
    label: 'Switch Value',
    initialValue: false,
    description: 'Toggle the switch on or off.',
  );

  final isEnabled = context.knobs.boolean(
    label: 'Enabled',
    initialValue: true,
    description: 'Enable or disable the switch.',
  );

  final scale = context.knobs.double.slider(
    label: 'Scale',
    initialValue: 0.7,
    min: 0.5,
    max: 1.5,
    divisions: 10,
    description: 'Scale factor for the switch.',
  );

  final activeTrackColor = context.knobs.color(
    label: 'Active Track Color',
    initialValue: Colors.black,
    description: 'Color of the track when the switch is on.',
  );

  final inactiveTrackColor = context.knobs.color(
    label: 'Inactive Track Color',
    initialValue: const Color(0xffD9D9D9),
    description: 'Color of the track when the switch is off.',
  );

  final thumbColor = context.knobs.color(
    label: 'Thumb Color',
    initialValue: Colors.white,
    description: 'Color of the switch thumb.',
  );

  final trackOutlineColor = context.knobs.color(
    label: 'Track Outline Color',
    initialValue: Colors.transparent,
    description: 'Color of the track outline.',
  );

  final isDarkTheme = context.knobs.boolean(
    label: 'Dark Theme',
    initialValue: false,
    description:
        'Toggle between light and dark theme to test context.isDarkMode.',
  );

  return WidgetbookScreenUtilFormWrapper(
    child: Theme(
      data: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      child: Builder(
        builder: (BuildContext context) {
          // Simulate dark mode for context.isDarkMode
          return Localizations.override(
            context: context,
            locale: const Locale('en'),
            child: Scaffold(
              appBar: AppBar(title: const Text('CustomSwitchButton Demo')),
              body: Center(
                child: Transform.scale(
                  scale: scale,
                  child: CustomSwitchButton(
                    value: value,
                    onChanged: isEnabled
                        ? (newValue) => print('Switch changed to: $newValue')
                        : null,
                    activeTrackColor: activeTrackColor,
                    inactiveTrackColor: inactiveTrackColor,
                    thumbColor: WidgetStatePropertyAll(thumbColor),
                    trackOutlineColor:
                        WidgetStatePropertyAll(trackOutlineColor),
                  ),
                ),
              ),
            ),
          );
        },
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
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff0D0D0D),
      ),
      debugShowCheckedModeBanner: false,
      locale: const Locale('en'),
      supportedLocales: const [Locale('en')],
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}
