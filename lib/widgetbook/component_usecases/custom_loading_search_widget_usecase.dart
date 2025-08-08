import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/widget/custom_loading_search_widget.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../utils/flutter_markdown.dart'; // If you have a MarkdownViewer widget

// Documentation Use Case
@widgetbook.UseCase(
  name: 'CustomLoadingSearchWidget Documentation',
  type: MarkdownViewer,
)
MarkdownViewer customLoadingSearchWidgetDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath:
        'assets/markdown/docs/custom_loading_search_widget_doc.md',
  );
}

// Interactive Use Case with Knobs
@widgetbook.UseCase(
  name: 'CustomLoadingSearchWidget with Knobs',
  type: CustomLoadingSearchWidget,
)
Widget customLoadingSearchWidgetWithKnobs(BuildContext context) {
  final message = context.knobs.stringOrNull(
    label: 'Message',
    initialValue: null,
    description:
        'Custom message for the loading widget. If null, defaults to "Searching..." or Arabic equivalent.',
  );

  final size = context.knobs.double.slider(
    label: 'Size',
    initialValue: 120.0,
    min: 50.0,
    max: 200.0,
    divisions: 15,
    description: 'Size of the Lottie animation (width and height).',
  );

  final showMessage = context.knobs.boolean(
    label: 'Show Message',
    initialValue: true,
    description: 'Toggle to show or hide the message text.',
  );

  final isArabic = context.knobs.boolean(
    label: 'Arabic Language',
    initialValue: false,
    description: 'Simulate Arabic language to test context.isArabic.',
  );

  return WidgetbookScreenUtilFormWrapper(
    child: Builder(
      builder: (BuildContext context) {
        // Mock the context.isArabic extension for testing
        if (isArabic) {
          // Simulate Arabic locale
          return Localizations.override(
            context: context,
            locale: const Locale('ar'),
            child: Scaffold(
              appBar:
                  AppBar(title: const Text('CustomLoadingSearchWidget Demo')),
              body: Center(
                child: CustomLoadingSearchWidget(
                  message: message,
                  size: size,
                  showMessage: showMessage,
                ),
              ),
            ),
          );
        } else {
          // Simulate English locale
          return Localizations.override(
            context: context,
            locale: const Locale('en'),
            child: Scaffold(
              appBar:
                  AppBar(title: const Text('CustomLoadingSearchWidget Demo')),
              body: Center(
                child: CustomLoadingSearchWidget(
                  message: message,
                  size: size,
                  showMessage: showMessage,
                ),
              ),
            ),
          );
        }
      },
    ),
  );
}

// Wrapper for Widgetbook with ScreenUtil
class WidgetbookScreenUtilFormWrapper extends StatelessWidget {
  final Widget child;

  const WidgetbookScreenUtilFormWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil with a design size (adjust as per your app's setup)
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812), // Example design size, adjust as needed
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return MaterialApp(
      home: child,
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
      ),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      locale: const Locale('en'), // Default locale
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        // Add necessary delegates for localization
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}
