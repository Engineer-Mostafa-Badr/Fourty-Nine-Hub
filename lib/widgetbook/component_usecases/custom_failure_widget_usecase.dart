import 'package:flutter/material.dart';
import 'package:fourtyninehub/widgetbook/component_usecases/text_input_widget_usecases.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../core/widget/custom_failure_widget.dart'; // Adjust path as needed
import '../utils/flutter_markdown.dart';

@widgetbook.UseCase(
  name: 'CustomFailureWidget Documentation',
  type: MarkdownViewer,
)
MarkdownViewer customFailureWidgetDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/custom_failure_widget_doc.md',
  );
}

@widgetbook.UseCase(
  name: 'CustomFailureWidget with Knobs',
  type: CustomFailureWidget,
)
Widget customFailureWidgetWidget(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Oops! Something went wrong',
  );

  final buttonTitle = context.knobs.stringOrNull(
    label: 'Button Title',
    initialValue: null, // null will show default "Refresh" with icon
  );

  final enableCustomTitle = context.knobs.boolean(
    label: 'Enable Custom Button Title',
    initialValue: false,
  );

  final titleFontSize = context.knobs.double.slider(
    label: 'Title Font Size',
    initialValue: 38,
    min: 16,
    max: 60,
  );

  final buttonWidth = context.knobs.double.slider(
    label: 'Button Width',
    initialValue: 343,
    min: 200,
    max: 400,
  );

  final buttonHeight = context.knobs.double.slider(
    label: 'Button Height',
    initialValue: 44,
    min: 35,
    max: 60,
  );

  final borderRadius = context.knobs.double.slider(
    label: 'Button Border Radius',
    initialValue: 15,
    min: 0,
    max: 30,
  );

  final showShadow = context.knobs.boolean(
    label: 'Show Button Shadow',
    initialValue: true,
  );

  final gradientIntensity = context.knobs.double.slider(
    label: 'Gradient Intensity',
    initialValue: 1.0,
    min: 0.3,
    max: 1.0,
  );

  int tapCount = 0;
  String lastTappedTime = 'Never';

  return WidgetbookScreenUtilFormWrapper(
    child: Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('CustomFailureWidget Demo'),
            actions: [
              IconButton(
                icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  // Toggle theme in real app
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Demo Container
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Color(0xFF1A1A1A) : Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          // Custom implementation since we can't use the original widget directly
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(),
                              
                              // Title
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              
                              const Spacer(flex: 5),
                              
                              // Button
                              InkWell(
                                onTap: () {
                                  tapCount++;
                                  lastTappedTime = DateTime.now().toString().substring(11, 19);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Retry button tapped! Count: $tapCount'),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  decoration: ShapeDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(-0.60, 0.50),
                                      end: Alignment(1.00, 0.50),
                                      colors: [
                                        (isDarkMode
                                            ? Color(0xFFCAD0F4).withOpacity(gradientIntensity)
                                            : Color(0xFF0B1035).withOpacity(gradientIntensity)),
                                        Color(0xFFF33D49).withOpacity(gradientIntensity)
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(borderRadius),
                                    ),
                                    shadows: showShadow ? [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 4),
                                        spreadRadius: 0,
                                      )
                                    ] : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (!enableCustomTitle || buttonTitle == null) ...[
                                        Icon(
                                          Icons.refresh,
                                          color: isDarkMode ? Color(0xFF0D0D0D) : Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      Text(
                                        enableCustomTitle && buttonTitle != null 
                                            ? buttonTitle 
                                            : 'Refresh',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode ? Color(0xFF0D0D0D) : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                            ],
                          ),
                          
                          // Theme indicator
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isDarkMode ? 'Dark Mode' : 'Light Mode',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Widget Status Card
                Expanded(
                  flex: 1,
                  child: Card(
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
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Title: "$title"'),
                                  Text('Button Title: ${enableCustomTitle && buttonTitle != null ? '"$buttonTitle"' : 'Default (Refresh)'}'),
                                  Text('Title Font Size: ${titleFontSize.toInt()}px'),
                                  Text('Button Size: ${buttonWidth.toInt()}x${buttonHeight.toInt()}'),
                                  Text('Border Radius: ${borderRadius.toInt()}px'),
                                  Text('Shadow: ${showShadow ? 'Enabled' : 'Disabled'}'),
                                  Text('Gradient Intensity: ${(gradientIntensity * 100).toInt()}%'),
                                  Text('Theme: ${isDarkMode ? 'Dark' : 'Light'} Mode'),
                                  Text('Tap Count: $tapCount'),
                                  Text('Last Tapped: $lastTappedTime'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

@widgetbook.UseCase(
  name: 'CustomFailureWidget States',
  type: CustomFailureWidget,
)
Widget customFailureWidgetStates(BuildContext context) {
  return WidgetbookScreenUtilFormWrapper(
    child: Scaffold(
      appBar: AppBar(title: const Text('CustomFailureWidget States')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Different Failure States',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            
            // Network Error State
            _buildStateDemo(
              context,
              'Network Error',
              'No internet connection\nPlease check your network',
              null, // Default refresh button
            ),
            
            const SizedBox(height: 20),
            
            // Server Error State
            _buildStateDemo(
              context,
              'Server Error',
              'Server is temporarily unavailable\nPlease try again later',
              'Try Again',
            ),
            
            const SizedBox(height: 20),
            
            // Data Not Found State
            _buildStateDemo(
              context,
              'Data Not Found',
              'No data available\nat the moment',
              'Reload',
            ),
            
            const SizedBox(height: 20),
            
            // Custom Error State
            _buildStateDemo(
              context,
              'Custom Error',
              'Something went wrong\nwith custom action',
              'Contact Support',
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildStateDemo(BuildContext context, String label, String title, String? buttonTitle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$label:',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark 
              ? Color(0xFF1A1A1A) 
              : Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.grey[700]! 
                : Colors.grey[300]!,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildCustomFailureDemo(context, title, buttonTitle, label),
        ),
      ),
    ],
  );
}

Widget _buildCustomFailureDemo(BuildContext context, String title, String? buttonTitle, String label) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Spacer(),
      
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      
      const Spacer(flex: 5),
      
      InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label action triggered!'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          width: 280,
          height: 40,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.60, 0.50),
              end: Alignment(1.00, 0.50),
              colors: [
                (isDarkMode ? Color(0xFFCAD0F4) : Color(0xFF0B1035)),
                Color(0xFFF33D49)
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (buttonTitle == null) ...[
                Icon(
                  Icons.refresh,
                  color: isDarkMode ? Color(0xFF0D0D0D) : Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                buttonTitle ?? 'Refresh',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Color(0xFF0D0D0D) : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      
      const SizedBox(height: 16),
    ],
  );
}

@widgetbook.UseCase(
  name: 'CustomFailureWidget Examples',
  type: CustomFailureWidget,
)
Widget customFailureWidgetExamples(BuildContext context) {
  return WidgetbookScreenUtilFormWrapper(
    child: DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CustomFailureWidget Examples'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Network'),
              Tab(text: 'Server'),
              Tab(text: 'Empty State'),
              Tab(text: 'Custom'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Network Error Tab
            _buildExamplePage(
              context,
              'Network Connection Failed',
              'Unable to connect to the internet\nCheck your connection and try again',
              null,
              Icons.wifi_off,
              'This is commonly used when the app cannot reach the server due to network issues.',
            ),
            
            // Server Error Tab
            _buildExamplePage(
              context,
              'Server Error',
              'Our servers are experiencing issues\nWe\'re working to fix this',
              'Contact Support',
              Icons.error_outline,
              'Used when the server returns 500+ errors or is temporarily unavailable.',
            ),
            
            // Empty State Tab
            _buildExamplePage(
              context,
              'Empty State',
              'No content found\nTry refreshing or come back later',
              'Reload Content',
              Icons.inbox,
              'Perfect for when API returns empty results or no data is available.',
            ),
            
            // Custom Tab
            _buildExamplePage(
              context,
              'Custom Action',
              'Feature temporarily unavailable\nPlease use alternative method',
              'Go to Help',
              Icons.help_outline,
              'Customize the button text and action for specific use cases.',
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildExamplePage(
  BuildContext context,
  String label,
  String title,
  String? buttonTitle,
  IconData icon,
  String description,
) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        // Description Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Example Widget
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Color(0xFF1A1A1A) 
                  : Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey[700]! 
                    : Colors.grey[300]!,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildCustomFailureDemo(context, title, buttonTitle, label),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Code Preview Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Code Example:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '''CustomFailureWidget(
  title: "$title",
  ${buttonTitle != null ? 'buttonTitle: "$buttonTitle",' : '// buttonTitle: null (shows refresh icon)'}
  onPressed: () => handleRetry(),
)''',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.black87,
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