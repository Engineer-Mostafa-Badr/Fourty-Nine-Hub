import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../core/widget/network_alert_banner.dart';
import '../../res/style/app_colors.dart';
import '../utils/flutter_markdown.dart';

@widgetbook.UseCase(
  name: 'NetworkAlertBanner Documentation',
  type: MarkdownViewer,
)
MarkdownViewer networkAlertBannerDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/network_alert_banner_doc.md',
  );
}

@widgetbook.UseCase(
  name: 'NetworkAlertBanner with Knobs',
  type: NetworkAlertBanner,
)
Widget networkAlertBannerWithKnobs(BuildContext context) {
  final isConnected = context.knobs.boolean(
    label: 'Is Connected',
    initialValue: false,
    description: 'Toggle network connection status',
  );

  final backgroundColor = context.knobs.listOrNull(
    label: 'Background Color',
    options: [
      'Primary Dark',
      'Red',
      'Orange',
      'Blue',
      'Custom',
    ],
    initialOption: 'Primary Dark',
  );

  final message = context.knobs.string(
    label: 'Custom Message',
    initialValue: 'No Internet Connection',
    description: 'Custom message to display',
  );

  final showAnimation = context.knobs.boolean(
    label: 'Show with Animation',
    initialValue: true,
    description: 'Animate banner appearance',
  );

  Color getBackgroundColor() {
    switch (backgroundColor) {
      case 'Red':
        return Colors.red;
      case 'Orange':
        return Colors.orange;
      case 'Blue':
        return Colors.blue;
      case 'Custom':
        return const Color(0xFF9C27B0);
      default:
        return AppColors.PRIMARY_COLOR_DARK;
    }
  }

  Widget banner = Container(
    color: getBackgroundColor(),
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    child: Text(
      message,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );

  if (isConnected) {
    banner = const SizedBox.shrink();
  }

  return Scaffold(
    appBar: AppBar(title: const Text('NetworkAlertBanner Demo')),
    body: Column(
      children: [
        // Banner at top
        if (showAnimation)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: banner,
          )
        else
          banner,
        
        // Demo content
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isConnected ? Icons.wifi : Icons.wifi_off,
                  size: 64,
                  color: isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  isConnected ? 'Connected' : 'Disconnected',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: isConnected ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Banner Status:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isConnected 
                            ? 'Banner is hidden (SizedBox.shrink())' 
                            : 'Banner is visible',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Usage:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'This banner automatically shows when isConnected is false and hides when true. Perfect for network status indicators at the top of your app.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'NetworkAlertBanner Positioning Demo',
  type: NetworkAlertBanner,
)
Widget networkAlertBannerPositioningDemo(BuildContext context) {
  final position = context.knobs.list(
    label: 'Banner Position',
    options: ['Top', 'Bottom', 'Floating'],
    initialOption: 'Top',
  );

  final isConnected = context.knobs.boolean(
    label: 'Is Connected',
    initialValue: false,
  );

  Widget banner = NetworkAlertBanner(isConnected: isConnected);

  Widget buildFloatingBanner() {
    if (isConnected) return const SizedBox.shrink();
    return Positioned(
      top: 100,
      left: 16,
      right: 16,
      child: Card(
        color: AppColors.PRIMARY_COLOR_DARK,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.wifi_off, color: Colors.white),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'No Internet Connection',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  return Scaffold(
    appBar: AppBar(title: const Text('Banner Positioning Demo')),
    body: Stack(
      children: [
        Column(
          children: [
            // Top banner
            if (position == 'Top') banner,
            
            // Content
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('List Item ${index + 1}'),
                  subtitle: Text('Subtitle for item ${index + 1}'),
                ),
              ),
            ),
            
            // Bottom banner
            if (position == 'Bottom') banner,
          ],
        ),
        
        // Floating banner
        if (position == 'Floating') buildFloatingBanner(),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'NetworkAlertBanner States Demo',
  type: NetworkAlertBanner,
)
Widget networkAlertBannerStatesDemo(BuildContext context) {
  final connectionState = context.knobs.list(
    label: 'Connection State',
    options: ['Connected', 'Disconnected', 'Connecting', 'Error'],
    initialOption: 'Disconnected',
  );

  Widget buildBanner() {
    switch (connectionState) {
      case 'Connected':
        return Container(
          color: Colors.green,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Connected to Internet',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        );
      case 'Connecting':
        return Container(
          color: Colors.orange,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Connecting...',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      case 'Error':
        return Container(
          color: Colors.red,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Connection Error',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      default:
        return NetworkAlertBanner(isConnected: false);
    }
  }

  return Scaffold(
    appBar: AppBar(title: const Text('Banner States Demo')),
    body: Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: buildBanner(),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current State: $connectionState',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Different connection states:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text('• Connected: Green banner with success message'),
                        const Text('• Disconnected: Dark red banner (original)'),
                        const Text('• Connecting: Orange banner with loading indicator'),
                        const Text('• Error: Red banner with error icon'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}