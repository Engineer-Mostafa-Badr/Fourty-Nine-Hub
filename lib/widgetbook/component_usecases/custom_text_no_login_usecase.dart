import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../core/widget/custom_text_no_login.dart';
import '../../res/style/app_colors.dart';
import '../utils/flutter_markdown.dart';

@widgetbook.UseCase(
  name: 'CustomTextNoLogin Documentation',
  type: MarkdownViewer,
)
MarkdownViewer customTextNoLoginDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/custom_text_no_login_doc.md',
  );
}

@widgetbook.UseCase(
  name: 'CustomTextNoLogin Original',
  type: CustomTextNoLogin,
)
Widget customTextNoLoginOriginal(BuildContext context) {
  final containerSize = context.knobs.double.slider(
    label: 'Container Size',
    initialValue: 500.0,
    min: 200.0,
    max: 600.0,
  );

  final borderWidth = context.knobs.double.slider(
    label: 'Border Width',
    initialValue: 4.0,
    min: 1.0,
    max: 10.0,
  );

  final customText = context.knobs.string(
    label: 'Custom Text',
    initialValue: 'Please Login, Register to enjoy the app',
  );

  final isDarkTheme = context.knobs.boolean(
    label: 'Dark Theme',
    initialValue: false,
  );

  return Theme(
    data: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
    child: Scaffold(
      appBar: AppBar(title: const Text('CustomTextNoLogin Original')),
      body: Center(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login dialog would appear here')),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: borderWidth,
                ),
              ),
              child: Center(
                child: Text(
                  customText,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'CustomTextNoLoginNew',
  type: CustomTextNoLoginNew,
)
Widget customTextNoLoginNew(BuildContext context) {
  final fontSize = context.knobs.double.slider(
    label: 'Font Size',
    initialValue: 50.0,
    min: 20.0,
    max: 80.0,
  );

  final customText = context.knobs.string(
    label: 'Custom Text',
    initialValue: 'Register/Login \n To enjoy App',
  );

  final textColor = context.knobs.listOrNull(
    label: 'Text Color',
    options: ['Primary', 'Blue', 'Green', 'Red', 'Purple'],
    initialOption: 'Primary',
  );

  final isDarkTheme = context.knobs.boolean(
    label: 'Dark Theme',
    initialValue: false,
  );

  Color getTextColor(BuildContext context) {
    switch (textColor) {
      case 'Blue':
        return Colors.blue;
      case 'Green':
        return Colors.green;
      case 'Red':
        return Colors.red;
      case 'Purple':
        return Colors.purple;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  return Theme(
    data: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
    child: Scaffold(
      appBar: AppBar(title: const Text('CustomTextNoLoginNew')),
      body: Center(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login dialog would appear here')),
              );
            },
            child: Center(
              child: Text(
                customText,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: getTextColor(context),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'CustomNotLogged with Progress',
  type: CustomNotLogged,
)
Widget customNotLoggedWithProgress(BuildContext context) {
  final totalSteps = context.knobs.int.slider(
    label: 'Total Steps',
    initialValue: 20,
    min: 10,
    max: 50,
  );

  final currentStep = context.knobs.int.slider(
    label: 'Current Step',
    initialValue: 15,
    min: 0,
    max: totalSteps,
  );

  final circleSize = context.knobs.double.slider(
    label: 'Circle Size',
    initialValue: 300.0,
    min: 200.0,
    max: 400.0,
  );

  final stepSize = context.knobs.double.slider(
    label: 'Step Size',
    initialValue: 20.0,
    min: 10.0,
    max: 30.0,
  );

  final selectedColor = context.knobs.listOrNull(
    label: 'Selected Color',
    options: ['Primary', 'Blue', 'Green', 'Orange', 'Purple'],
    initialOption: 'Primary',
  );

  final customText = context.knobs.string(
    label: 'Center Text',
    initialValue: 'Register/Login \n To enjoy App',
  );

  final isDarkTheme = context.knobs.boolean(
    label: 'Dark Theme',
    initialValue: false,
  );

  Color getSelectedColor() {
    switch (selectedColor) {
      case 'Blue':
        return Colors.blue;
      case 'Green':
        return Colors.green;
      case 'Orange':
        return Colors.orange;
      case 'Purple':
        return Colors.purple;
      default:
        return AppColors.PRIMARY_COLOR;
    }
  }

  return Theme(
    data: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
    child: Scaffold(
      appBar: AppBar(title: const Text('CustomNotLogged with Progress')),
      body: Center(
        child: SizedBox(
          width: circleSize,
          height: circleSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularStepProgressIndicator(
                totalSteps: totalSteps,
                stepSize: stepSize,
                selectedStepSize: stepSize,
                currentStep: currentStep,
                width: circleSize,
                height: circleSize,
                padding: 0.5,
                selectedColor: getSelectedColor(),
                unselectedColor: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login dialog would appear here')),
                  );
                },
                child: Center(
                  child: Text(
                    customText,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'CustomTextNoLogin Variations',
  type: CustomTextNoLogin,
)
Widget customTextNoLoginVariations(BuildContext context) {
  final variation = context.knobs.list(
    label: 'Variation',
    options: ['Original Circle', 'New Text Only', 'Progress Circle', 'Custom Design'],
    initialOption: 'Progress Circle',
  );

  final isDarkTheme = context.knobs.boolean(
    label: 'Dark Theme',
    initialValue: false,
  );

  final animateEntrance = context.knobs.boolean(
    label: 'Animate Entrance',
    initialValue: true,
  );

  Widget buildVariation() {
    switch (variation) {
      case 'Original Circle':
        return const CustomTextNoLogin();
        
      case 'New Text Only':
        return const CustomTextNoLoginNew();
        
      case 'Progress Circle':
        return const CustomNotLogged();
        
      case 'Custom Design':
        return Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.PRIMARY_COLOR,
                  AppColors.PRIMARY_COLOR.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please login or register\nto continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login action triggered')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.PRIMARY_COLOR,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),
        );
        
      default:
        return const CustomNotLogged();
    }
  }

  Widget content = buildVariation();

  if (animateEntrance) {
    content = TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: content,
    );
  }

  return Theme(
    data: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
    child: Scaffold(
      appBar: AppBar(title: Text('$variation Demo')),
      body: content,
    ),
  );
}

@widgetbook.UseCase(
  name: 'CustomTextNoLogin Interactive Demo',
  type: CustomTextNoLogin,
)
Widget customTextNoLoginInteractiveDemo(BuildContext context) {
  final showTooltips = context.knobs.boolean(
    label: 'Show Tooltips',
    initialValue: true,
  );

  final enableHapticFeedback = context.knobs.boolean(
    label: 'Enable Haptic Feedback',
    initialValue: true,
  );

  final showDescription = context.knobs.boolean(
    label: 'Show Description',
    initialValue: true,
  );

  return Scaffold(
    appBar: AppBar(title: const Text('Interactive Login Prompts')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (showDescription) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login Required Widgets',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'These widgets are shown when users need to authenticate. They provide clear calls-to-action and visual appeal to encourage registration or login.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Original Circle
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Original Circle Design',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: showTooltips
                      ? Tooltip(
                          message: 'Tap to trigger login',
                          child: const CustomTextNoLogin(),
                        )
                      : const CustomTextNoLogin(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // New Text Only
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Simplified Text Design',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 150,
                    child: showTooltips
                      ? Tooltip(
                          message: 'Tap to trigger login',
                          child: const CustomTextNoLoginNew(),
                        )
                      : const CustomTextNoLoginNew(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Progress Circle
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Progress Circle Design',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: showTooltips
                      ? Tooltip(
                          message: 'Tap to trigger login',
                          child: const CustomNotLogged(),
                        )
                      : const CustomNotLogged(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Usage guidelines
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Usage Guidelines',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('• Use Original Circle for prominent full-screen prompts'),
                const Text('• Use New Text for minimal, clean interfaces'),
                const Text('• Use Progress Circle to show user engagement or achievement'),
                const Text('• All variants trigger login dialogs when tapped'),
                const Text('• Consider dark/light theme compatibility'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}