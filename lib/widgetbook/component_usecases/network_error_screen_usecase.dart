import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../core/widget/network_error_screen.dart';
import '../../res/style/app_colors.dart';
import '../utils/flutter_markdown.dart';

@widgetbook.UseCase(
  name: 'NetworkErrorScreen Documentation',
  type: MarkdownViewer,
)
MarkdownViewer networkErrorScreenDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/network_error_screen_doc.md',
  );
}

@widgetbook.UseCase(
  name: 'NetworkErrorScreen with Knobs',
  type: NetworkErrorScreen,
)
Widget networkErrorScreenWithKnobs(BuildContext context) {
  final iconSize = context.knobs.double.slider(
    label: 'Icon Size',
    initialValue: 60.0,
    min: 30.0,
    max: 100.0,
  );

  final containerSize = context.knobs.double.slider(
    label: 'Container Size',
    initialValue: 120.0,
    min: 80.0,
    max: 200.0,
  );

  final titleText = context.knobs.string(
    label: 'Title Text',
    initialValue: 'No Internet Connection',
  );

  final descriptionText = context.knobs.string(
    label: 'Description Text',
    initialValue: 'Please check your internet connection and try again',
  );

  final buttonText = context.knobs.string(
    label: 'Button Text',
    initialValue: 'Retry',
  );

  final iconType = context.knobs.list(
    label: 'Icon Type',
    options: [
      'wifi_off_rounded',
      'signal_wifi_off',
      'cloud_off',
      'error_outline',
      'refresh',
    ],
    initialOption: 'wifi_off_rounded',
  );

  final showAnimation = context.knobs.boolean(
    label: 'Show Animation',
    initialValue: true,
  );

  final isDarkTheme = context.knobs.boolean(
    label: 'Dark Theme',
    initialValue: false,
  );

  IconData getIcon() {
    switch (iconType) {
      case 'signal_wifi_off':
        return Icons.signal_wifi_off;
      case 'cloud_off':
        return Icons.cloud_off;
      case 'error_outline':
        return Icons.error_outline;
      case 'refresh':
        return Icons.refresh;
      default:
        return Icons.wifi_off_rounded;
    }
  }

  return Theme(
    data: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
    child: Scaffold(
      backgroundColor: isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Network error icon with animation
                showAnimation
                    ? AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: containerSize,
                        height: containerSize,
                        decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          getIcon(),
                          size: iconSize,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      )
                    : Container(
                        width: containerSize,
                        height: containerSize,
                        decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          getIcon(),
                          size: iconSize,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                const SizedBox(height: 32),
                
                // Title
                Text(
                  titleText,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Description
                Text(
                  descriptionText,
                  style: TextStyle(
                    fontSize: 16,
                    color: (isDarkTheme ? Colors.white : Colors.black)
                        .withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Retry button
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Retry button pressed!')),
                    );
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'NetworkErrorScreen Variations',
  type: NetworkErrorScreen,
)
Widget networkErrorScreenVariations(BuildContext context) {
  final variation = context.knobs.list(
    label: 'Screen Variation',
    options: [
      'Default',
      'Minimal',
      'Detailed',
      'Custom Actions',
      'With Illustration',
    ],
    initialOption: 'Default',
  );

  final isDark = context.knobs.boolean(
    label: 'Dark Mode',
    initialValue: false,
  );

  Widget buildVariation() {
    switch (variation) {
      case 'Minimal':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No Connection',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );

      case 'Detailed':
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    size: 70,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Connection Problem',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'It looks like you\'re not connected to the internet. Please check your connection and try again.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Troubleshooting tips:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• Check your WiFi connection', style: TextStyle(color: Colors.grey[600])),
                    Text('• Try mobile data if available', style: TextStyle(color: Colors.grey[600])),
                    Text('• Restart your router', style: TextStyle(color: Colors.grey[600])),
                    Text('• Contact your ISP if problems persist', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text('Try Again', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );

      case 'Custom Actions':
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_off,
                  size: 100,
                  color: Colors.orange,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Offline Mode',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'You\'re currently offline. Some features may not be available.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.PRIMARY_COLOR,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.offline_pin),
                      label: const Text('Go Offline'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                  label: const Text('Network Settings'),
                ),
              ],
            ),
          ),
        );

      case 'With Illustration':
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Custom illustration placeholder
                Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.router,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 8),
                      Icon(
                        Icons.phone_android,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Oops! No Internet',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Check your connection and try again',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Refresh',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      default:
        return const NetworkErrorScreen();
    }
  }

  return Theme(
    data: isDark ? ThemeData.dark() : ThemeData.light(),
    child: Scaffold(
      body: SafeArea(child: buildVariation()),
    ),
  );
}