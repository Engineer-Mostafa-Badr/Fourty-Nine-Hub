import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../core/widget/custom_scaffold.dart';
import '../../res/style/app_colors.dart';
import '../utils/flutter_markdown.dart';
import 'text_input_widget_usecases.dart';
import '../utils/provider_wrapper.dart';

// ================== CustomScaffold Basic ==================

@widgetbook.UseCase(
  name: 'CustomScaffold Basic with Knobs',
  type: CustomScaffold,
)
Widget customScaffoldBasicWidget(BuildContext context) {
  final showNavBar = context.knobs.boolean(
    label: 'Show Navigation Bar',
    initialValue: true,
  );

  final enableCustomAppBar = context.knobs.boolean(
    label: 'Enable Custom AppBar',
    initialValue: false,
  );

  final extendBody = context.knobs.boolean(
    label: 'Extend Body',
    initialValue: false,
  );

  final extendBodyBehindAppBar = context.knobs.boolean(
    label: 'Extend Body Behind AppBar',
    initialValue: false,
  );

  final resizeToAvoidBottomInset = context.knobs.booleanOrNull(
    label: 'Resize to Avoid Bottom Inset',
    initialValue: null,
  );

  final backgroundColor = context.knobs.listOrNull(
    label: 'Background Color',
    options: [
      'Default',
      'White',
      'Grey',
      'Light Blue',
      'Light Green',
    ],
    initialOption: 'Default',
  );

  Color? selectedBackgroundColor;
  switch (backgroundColor) {
    case 'White':
      selectedBackgroundColor = Colors.white;
      break;
    case 'Grey':
      selectedBackgroundColor = Colors.grey[100];
      break;
    case 'Light Blue':
      selectedBackgroundColor = Colors.blue[50];
      break;
    case 'Light Green':
      selectedBackgroundColor = Colors.green[50];
      break;
  }

  final appBarTitle = context.knobs.string(
    label: 'AppBar Title',
    initialValue: 'CustomScaffold Demo',
  );

  return WidgetbookProviderWrapper(
    child: WidgetbookScreenUtilFormWrapper(
      child: CustomScaffold(
        backgroundColor: selectedBackgroundColor,
        showNavBAr: showNavBar,
        enableCustomAppBar: enableCustomAppBar,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: enableCustomAppBar ? AppColors.PRIMARY_COLOR : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CustomScaffold Features',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        icon: Icons.navigation,
                        title: 'Floating Navigation',
                        description: 'Draggable floating navigation panel',
                        enabled: showNavBar,
                      ),
                      _buildFeatureItem(
                        icon: Icons.menu,
                        title: 'Side Ruler',
                        description: 'Quick access navigation drawer',
                        enabled: showNavBar,
                      ),
                      _buildFeatureItem(
                        icon: Icons.gpp_maybe,
                        title: 'Custom AppBar',
                        description: 'Enhanced app bar with rounded body',
                        enabled: enableCustomAppBar,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Navigation Instructions',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text('• Tap the left edge to open side navigation'),
                      const Text(
                          '• Use the floating button to toggle navigation'),
                      const Text('• Navigation requires user authentication'),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('CustomScaffold Demo Button Pressed!'),
                      ),
                    );
                  },
                  child: const Text('Test Button'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// ================== CustomScaffold Documentation ==================

@widgetbook.UseCase(
  name: 'CustomScaffold Documentation',
  type: MarkdownViewer,
)
MarkdownViewer customScaffoldDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/custom_scaffold_doc.md',
  );
}

// ================== CustomScaffold Layout Variations ==================

@widgetbook.UseCase(
  name: 'CustomScaffold Layout Variations',
  type: CustomScaffold,
)
Widget customScaffoldLayoutVariationsWidget(BuildContext context) {
  final layoutType = context.knobs.list(
    label: 'Layout Type',
    options: [
      'Standard',
      'Custom AppBar',
      'Extended Body',
      'Behind AppBar',
      'No Navigation',
    ],
    initialOption: 'Standard',
  );

  bool enableCustomAppBar = false;
  bool extendBody = false;
  bool extendBodyBehindAppBar = false;
  bool showNavBar = true;
  Color? scaffoldBgColor;

  switch (layoutType) {
    case 'Custom AppBar':
      enableCustomAppBar = true;
      scaffoldBgColor = AppColors.PRIMARY_COLOR;
      break;
    case 'Extended Body':
      extendBody = true;
      break;
    case 'Behind AppBar':
      extendBodyBehindAppBar = true;
      break;
    case 'No Navigation':
      showNavBar = false;
      break;
  }

  return WidgetbookProviderWrapper(
    child: WidgetbookScreenUtilFormWrapper(
      child: CustomScaffold(
        enableCustomAppBar: enableCustomAppBar,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        showNavBAr: showNavBar,
        scaffoldBackgroundWithAppBarColor: scaffoldBgColor,
        appBar: AppBar(
          title: Text('Layout: $layoutType'),
          backgroundColor: enableCustomAppBar
              ? AppColors.PRIMARY_COLOR
              : Theme.of(context).appBarTheme.backgroundColor,
          elevation: extendBodyBehindAppBar ? 0 : null,
        ),
        body: Container(
          decoration: extendBodyBehindAppBar
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.withOpacity(0.1),
                      Colors.white,
                    ],
                  ),
                )
              : null,
          child: ListView(
            padding: EdgeInsets.only(
              top: extendBodyBehindAppBar ? kToolbarHeight + 40 : 16,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Layout Configuration',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      _buildConfigItem('Custom AppBar', enableCustomAppBar),
                      _buildConfigItem('Extend Body', extendBody),
                      _buildConfigItem('Behind AppBar', extendBodyBehindAppBar),
                      _buildConfigItem('Show Navigation', showNavBar),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Layout Description',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(_getLayoutDescription(layoutType)),
                    ],
                  ),
                ),
              ),
              // Sample content cards
              for (int i = 1; i <= 5; i++)
                Card(
                  margin: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      child: Text('$i'),
                    ),
                    title: Text('Sample Content Item $i'),
                    subtitle:
                        Text('This is a sample item to show layout behavior'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

// ================== CustomScaffold with Floating Action Button ==================

@widgetbook.UseCase(
  name: 'CustomScaffold with FAB',
  type: CustomScaffold,
)
Widget customScaffoldWithFABWidget(BuildContext context) {
  final fabLocation = context.knobs.list(
    label: 'FAB Location',
    options: [
      'centerFloat',
      'endFloat',
      'centerDocked',
      'endDocked',
      'startTop',
      'centerTop',
      'endTop',
    ],
    initialOption: 'centerFloat',
  );

  FloatingActionButtonLocation selectedLocation;
  switch (fabLocation) {
    case 'centerFloat':
      selectedLocation = FloatingActionButtonLocation.centerFloat;
      break;
    case 'endFloat':
      selectedLocation = FloatingActionButtonLocation.endFloat;
      break;
    case 'centerDocked':
      selectedLocation = FloatingActionButtonLocation.centerDocked;
      break;
    case 'endDocked':
      selectedLocation = FloatingActionButtonLocation.endDocked;
      break;
    case 'startTop':
      selectedLocation = FloatingActionButtonLocation.startTop;
      break;
    case 'centerTop':
      selectedLocation = FloatingActionButtonLocation.centerTop;
      break;
    case 'endTop':
      selectedLocation = FloatingActionButtonLocation.endTop;
      break;
    default:
      selectedLocation = FloatingActionButtonLocation.centerFloat;
  }

  final showBottomNav = context.knobs.boolean(
    label: 'Show Bottom Navigation',
    initialValue: false,
  );

  return WidgetbookProviderWrapper(
    child: WidgetbookScreenUtilFormWrapper(
      child: CustomScaffold(
        appBar: AppBar(
          title: const Text('CustomScaffold with FAB'),
          backgroundColor: AppColors.PRIMARY_COLOR,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('FAB Pressed!')),
            );
          },
          backgroundColor: AppColors.SECONDARY_COLOR,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: selectedLocation,
        bottomNavigationBar: showBottomNav
            ? BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              )
            : null,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.rocket_launch,
                        size: 64,
                        color: AppColors.PRIMARY_COLOR,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'FAB Location: $fabLocation',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Floating Action Button is positioned at $fabLocation',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Bottom Navigation: ${showBottomNav ? "Enabled" : "Disabled"}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
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

Widget _buildConfigItem(String label, bool value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: value ? Colors.green[100] : Colors.red[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value ? 'ON' : 'OFF',
            style: TextStyle(
              fontSize: 12,
              color: value ? Colors.green[800] : Colors.red[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildFeatureItem({
  required IconData icon,
  required String title,
  required String description,
  required bool enabled,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(
          icon,
          color: enabled ? Colors.green : Colors.grey,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: enabled ? Colors.black : Colors.grey,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: enabled ? Colors.black54 : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: enabled ? Colors.green[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            enabled ? 'Enabled' : 'Disabled',
            style: TextStyle(
              fontSize: 10,
              color: enabled ? Colors.green[800] : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

String _getLayoutDescription(String layoutType) {
  switch (layoutType) {
    case 'Standard':
      return 'Standard layout with default AppBar and body positioning. Navigation is enabled.';
    case 'Custom AppBar':
      return 'Custom AppBar mode with primary color background and rounded body container with 50px top border radius.';
    case 'Extended Body':
      return 'Body extends behind the floating action button and bottom navigation bar.';
    case 'Behind AppBar':
      return 'Body content extends behind the AppBar, useful for immersive experiences.';
    case 'No Navigation':
      return 'Navigation features are disabled, showing only the basic scaffold structure.';
    default:
      return 'Unknown layout configuration.';
  }
}
