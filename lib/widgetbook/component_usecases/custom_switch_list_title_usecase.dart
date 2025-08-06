import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/utils/hex_color_helper.dart';
import 'package:fourtyninehub/core/widget/custom_switch_list_title.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../utils/flutter_markdown.dart';

// Documentation Use Case
@widgetbook.UseCase(
  name: 'CustomSwitchListTile Documentation',
  type: MarkdownViewer,
)
MarkdownViewer customSwitchListTileDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/custom_switch_list_tile_doc.md',
  );
}

// Interactive Use Case with Knobs
@widgetbook.UseCase(
  name: 'CustomSwitchListTile with Knobs',
  type: CustomSwitchListTile,
)
Widget customSwitchListTileWithKnobs(BuildContext context) {
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

  final showSecondary = context.knobs.boolean(
    label: 'Show Secondary Icon',
    initialValue: true,
    description: 'Show or hide the secondary icon.',
  );

  final secondaryIcon = context.knobs.list<IconData>(
    label: 'Secondary Icon',
    options: [
      Icons.notifications,
      Icons.message,
      Icons.favorite,
      Icons.settings,
    ],
    labelBuilder: (value) => value.toString(),
    initialOption: Icons.notifications,
  );

  final showTitle = context.knobs.boolean(
    label: 'Show Title',
    initialValue: true,
    description: 'Show or hide the title text.',
  );

  final titleText = context.knobs.string(
    label: 'Title Text',
    initialValue: 'Switch Option',
    description: 'Text for the title.',
  );

  final showSubtitle = context.knobs.boolean(
    label: 'Show Subtitle',
    initialValue: true,
    description: 'Show or hide the subtitle text.',
  );

  final subtitleText = context.knobs.string(
    label: 'Subtitle Text',
    initialValue: 'Additional information',
    description: 'Text for the subtitle.',
  );

  final activeTrackColor = context.knobs.color(
    label: 'Active Track Color',
    initialValue: HexColor('4CDA64'),
    description: 'Color of the track when the switch is on.',
  );

  final thumbColor = context.knobs.color(
    label: 'Thumb Color',
    initialValue: AppColors.PRIMARY_COLOR,
    description: 'Color of the switch thumb.',
  );

  final trackOutlineColor = context.knobs.color(
    label: 'Track Outline Color',
    initialValue: AppColors.PRIMARY_COLOR,
    description: 'Color of the track outline when switch is off.',
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
          return Scaffold(
            appBar: AppBar(title: const Text('CustomSwitchListTile Demo')),
            body: Center(
              child: CustomSwitchListTile(
                value: value,
                onChanged: isEnabled
                    ? (newValue) => print('Switch changed to: $newValue')
                    : null,
                secondary:
                    showSecondary ? Icon(secondaryIcon, size: 24.0) : null,
                title: showTitle ? Text(titleText) : null,
                subtitle: showSubtitle ? Text(subtitleText) : null,
                // activeTrackColor: activeTrackColor,
                // thumbColor: WidgetStatePropertyAll(thumbColor),
                trackOutlineColor: WidgetStatePropertyAll(trackOutlineColor),
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
