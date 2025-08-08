# CustomFailureWidget Documentation

## Overview

`CustomFailureWidget` is a specialized Flutter widget designed to display error states and failures in a visually appealing and user-friendly manner. It provides a consistent UI for handling various error scenarios such as network failures, server errors, empty states, and custom error conditions. The widget features a gradient button with customizable styling and automatic dark/light theme adaptation.

## Widget Structure

```dart
class CustomFailureWidget extends StatelessWidget {
  const CustomFailureWidget({
    super.key,
    required this.title,
    this.buttonTitle,
    this.onPressed,
  });
  
  final String title;
  final String? buttonTitle;
  final VoidCallback? onPressed;
  
  @override
  Widget build(BuildContext context) {
    // Implementation with theme-aware gradient button
    // and responsive design using ScreenUtil
  }
}
```

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | `String` | Main error message displayed to the user |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `buttonTitle` | `String?` | `null` | Custom text for the action button. If null, shows "Refresh" with refresh icon |
| `onPressed` | `VoidCallback?` | `null` | Callback function executed when the button is tapped |

## Key Features

### 🎨 **Theme Adaptive Design**
- Automatically adapts to light and dark themes
- Dynamic gradient colors based on theme
- Proper contrast ratios for accessibility

### 🔄 **Smart Button Behavior**
- Default "Refresh" button with icon when `buttonTitle` is null
- Custom button text without icon when `buttonTitle` is provided
- Gradient background with shadow effects

### 📱 **Responsive Layout**
- Uses ScreenUtil for responsive sizing
- Maintains proper proportions across different screen sizes
- Optimized spacing and typography

### ⚡ **Performance Optimized**
- StatelessWidget for minimal rebuilds
- Efficient gradient rendering
- Lightweight implementation

## Usage Examples

### Basic Network Error
```dart
class NetworkErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomFailureWidget(
        title: 'No Internet Connection\nPlease check your network and try again',
        onPressed: () => _retryNetworkCall(),
      ),
    );
  }

  void _retryNetworkCall() {
    // Implement network retry logic
    NetworkService.retryLastRequest();
  }
}
```

### Server Error with Custom Button
```dart
class ServerErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomFailureWidget(
        title: 'Server Error\nOur servers are temporarily unavailable',
        buttonTitle: 'Contact Support',
        onPressed: () => _contactSupport(),
      ),
    );
  }

  void _contactSupport() {
    Navigator.pushNamed(context, '/support');
  }
}
```

### Empty State Example
```dart
class EmptyDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomFailureWidget(
      title: 'No Data Available\nTry refreshing or check back later',
      buttonTitle: 'Reload',
      onPressed: () => _reloadData(),
    );
  }

  void _reloadData() {
    context.read<DataBloc>().add(LoadDataEvent());
  }
}
```

### API Error Handling
```dart
class ApiErrorHandler extends StatelessWidget {
  final ApiException error;
  final VoidCallback onRetry;

  const ApiErrorHandler({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String? buttonTitle;

    switch (error.type) {
      case ApiErrorType.networkError:
        title = 'Connection Failed\nCheck your internet connection';
        buttonTitle = null; // Show default refresh
        break;
      case ApiErrorType.serverError:
        title = 'Server Error\nPlease try again later';
        buttonTitle = 'Retry';
        break;
      case ApiErrorType.unauthorized:
        title = 'Session Expired\nPlease login again';
        buttonTitle = 'Login';
        break;
      case ApiErrorType.forbidden:
        title = 'Access Denied\nYou don\'t have permission';
        buttonTitle = 'Go Back';
        break;
      default:
        title = 'Something went wrong\nPlease try again';
        buttonTitle = 'Retry';
    }

    return CustomFailureWidget(
      title: title,
      buttonTitle: buttonTitle,
      onPressed: error.type == ApiErrorType.unauthorized 
          ? () => Navigator.pushReplacementNamed(context, '/login')
          : onRetry,
    );
  }
}
```

### State Management Integration
```dart
class DataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        if (state is DataError) {
          return CustomFailureWidget(
            title: _getErrorMessage(state.error),
            buttonTitle: _getButtonTitle(state.error),
            onPressed: () => context.read<DataBloc>().add(RetryDataLoad()),
          );
        }
        
        if (state is DataEmpty) {
          return CustomFailureWidget(
            title: 'No Data Found\nTry adjusting your filters',
            buttonTitle: 'Reset Filters',
            onPressed: () => context.read<DataBloc>().add(ResetFiltersEvent()),
          );
        }
        
        // Handle other states...
        return DataListWidget(data: state.data);
      },
    );
  }

  String _getErrorMessage(Exception error) {
    if (error is NetworkException) {
      return 'Network Error\nPlease check your connection';
    } else if (error is ServerException) {
      return 'Server Error\nTry again in a few minutes';
    }
    return 'Unexpected Error\nSomething went wrong';
  }

  String? _getButtonTitle(Exception error) {
    if (error is NetworkException) return null; // Show refresh icon
    if (error is ServerException) return 'Try Again';
    return 'Retry';
  }
}
```

## Visual Design

### Light Theme Appearance
```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│    Oops! Something went wrong       │
│    Please try again later           │
│                                     │
│                                     │
│         ┌─────────────────┐         │
│         │  🔄  Refresh   │         │ ← Gradient Button
│         └─────────────────┘         │   (Dark to Red)
│                                     │
└─────────────────────────────────────┘
```

### Dark Theme Appearance
```
┌─────────────────────────────────────┐ ← Dark Background
│                                     │
│                                     │
│    Oops! Something went wrong       │ ← White Text
│    Please try again later           │
│                                     │
│                                     │
│         ┌─────────────────┐         │
│         │  🔄  Refresh   │         │ ← Gradient Button
│         └─────────────────┘         │   (Light to Red)
│                                     │
└─────────────────────────────────────┘
```

## Styling Details

### Typography
```dart
// Title Text Style
TextStyle(
  fontSize: 38.sp,
  fontWeight: FontWeight.bold,
  color: Theme.of(context).textTheme.bodyLarge?.color,
)

// Button Text Style
TextStyle(
  fontSize: 18.sp,
  fontWeight: FontWeight.bold,
  color: isDarkTheme ? Color(0xFF0D0D0D) : Colors.white,
)
```

### Gradient Configuration
```dart
// Light Theme Gradient
LinearGradient(
  begin: Alignment(-0.60, 0.50),
  end: Alignment(1.00, 0.50),
  colors: [
    Color(0xFF0B1035), // Dark Blue
    Color(0xFFF33D49), // Red
  ],
)

// Dark Theme Gradient
LinearGradient(
  begin: Alignment(-0.60, 0.50),
  end: Alignment(1.00, 0.50),
  colors: [
    Color(0xFFCAD0F4), // Light Purple
    Color(0xFFF33D49), // Red
  ],
)
```

### Button Specifications
```dart
Container(
  width: 343.w,
  height: 44.h,
  decoration: ShapeDecoration(
    gradient: gradientColors,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.r),
    ),
    shadows: [
      BoxShadow(
        color: Color(0x3F000000),
        blurRadius: 4,
        offset: Offset(0, 4),
        spreadRadius: 0,
      ),
    ],
  ),
)
```

## Advanced Usage Patterns

### Loading State Integration
```dart
class FailureWithLoadingScreen extends StatefulWidget {
  @override
  _FailureWithLoadingScreenState createState() => _FailureWithLoadingScreenState();
}

class _FailureWithLoadingScreenState extends State<FailureWithLoadingScreen> {
  bool isRetrying = false;

  @override
  Widget build(BuildContext context) {
    if (isRetrying) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Retrying...'),
          ],
        ),
      );
    }

    return CustomFailureWidget(
      title: 'Failed to load data\nPlease try again',
      onPressed: _handleRetry,
    );
  }

  Future<void> _handleRetry() async {
    setState(() => isRetrying = true);
    
    try {
      await Future.delayed(Duration(seconds: 2)); // Simulate API call
      // Handle success - navigate away or update state
      Navigator.pop(context);
    } catch (error) {
      // Stay on error screen
      setState(() => isRetrying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Retry failed: $error')),
      );
    }
  }
}
```

### Multi-Action Error Screen
```dart
class MultiActionFailureScreen extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onPrimaryAction;
  final VoidCallback onSecondaryAction;

  const MultiActionFailureScreen({
    required this.errorMessage,
    required this.onPrimaryAction,
    required this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomFailureWidget(
            title: errorMessage,
            buttonTitle: 'Try Again',
            onPressed: onPrimaryAction,
          ),
        ),
        
        // Secondary Action Button
        Padding(
          padding: EdgeInsets.all(16.w),
          child: TextButton(
            onPressed: onSecondaryAction,
            child: Text(
              'Go to Settings',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

### Animated Error Screen
```dart
class AnimatedFailureScreen extends StatefulWidget {
  final String title;
  final String? buttonTitle;
  final VoidCallback? onPressed;

  const AnimatedFailureScreen({
    required this.title,
    this.buttonTitle,
    this.onPressed,
  });

  @override
  _AnimatedFailureScreenState createState() => _AnimatedFailureScreenState();
}

class _AnimatedFailureScreenState extends State<AnimatedFailureScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomFailureWidget(
          title: widget.title,
          buttonTitle: widget.buttonTitle,
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
```

### Context-Aware Error Handling
```dart
class ContextAwareFailureWidget extends StatelessWidget {
  final Exception error;
  final VoidCallback onRetry;

  const ContextAwareFailureWidget({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final errorInfo = _analyzeError(error);
    
    return CustomFailureWidget(
      title: errorInfo.message,
      buttonTitle: errorInfo.actionText,
      onPressed: () => _handleAction(context, errorInfo),
    );
  }

  ErrorInfo _analyzeError(Exception error) {
    if (error is SocketException) {
      return ErrorInfo(
        message: 'No Internet Connection\nCheck your network settings',
        actionText: null, // Show refresh icon
        action: ErrorAction.retry,
      );
    }
    
    if (error is HttpException) {
      final statusCode = (error as HttpException).statusCode;
      switch (statusCode) {
        case 401:
          return ErrorInfo(
            message: 'Session Expired\nPlease login again',
            actionText: 'Login',
            action: ErrorAction.login,
          );
        case 403:
          return ErrorInfo(
            message: 'Access Denied\nInsufficient permissions',
            actionText: 'Go Back',
            action: ErrorAction.goBack,
          );
        case 500:
        case 502:
        case 503:
          return ErrorInfo(
            message: 'Server Error\nTry again in a few minutes',
            actionText: 'Retry',
            action: ErrorAction.retry,
          );
        default:
          return ErrorInfo(
            message: 'Request Failed\nPlease try again',
            actionText: 'Retry',
            action: ErrorAction.retry,
          );
      }
    }
    
    return ErrorInfo(
      message: 'Unexpected Error\nSomething went wrong',
      actionText: 'Retry',
      action: ErrorAction.retry,
    );
  }

  void _handleAction(BuildContext context, ErrorInfo errorInfo) {
    switch (errorInfo.action) {
      case ErrorAction.retry:
        onRetry();
        break;
      case ErrorAction.login:
        Navigator.pushReplacementNamed(context, '/login');
        break;
      case ErrorAction.goBack:
        Navigator.pop(context);
        break;
    }
  }
}

class ErrorInfo {
  final String message;
  final String? actionText;
  final ErrorAction action;

  ErrorInfo({
    required this.message,
    required this.actionText,
    required this.action,
  });
}

enum ErrorAction { retry, login, goBack }
```

## Common Error Scenarios

### Network Errors
```dart
// No Internet Connection
CustomFailureWidget(
  title: 'No Internet Connection\nPlease check your network and try again',
  // buttonTitle: null (shows refresh icon)
  onPressed: () => NetworkService.retry(),
)

// Timeout Error
CustomFailureWidget(
  title: 'Request Timeout\nThe server is taking too long to respond',
  buttonTitle: 'Try Again',
  onPressed: () => ApiService.retryLastRequest(),
)

// DNS Resolution Failed
CustomFailureWidget(
  title: 'Connection Failed\nUnable to reach the server',
  onPressed: () => ConnectivityService.checkAndRetry(),
)
```

### Server Errors
```dart
// Internal Server Error (500)
CustomFailureWidget(
  title: 'Server Error\nOur servers are experiencing issues',
  buttonTitle: 'Contact Support',
  onPressed: () => SupportService.openTicket(),
)

// Service Unavailable (503)
CustomFailureWidget(
  title: 'Service Unavailable\nThe service is temporarily down',
  buttonTitle: 'Try Later',
  onPressed: () => Navigator.pop(context),
)

// Bad Gateway (502)
CustomFailureWidget(
  title: 'Server Gateway Error\nThere\'s a problem with our servers',
  onPressed: () => ApiService.retryWithBackoff(),
)
```

### Authentication Errors
```dart
// Unauthorized (401)
CustomFailureWidget(
  title: 'Session Expired\nPlease login again to continue',
  buttonTitle: 'Login',
  onPressed: () => AuthService.redirectToLogin(),
)

// Forbidden (403)
CustomFailureWidget(
  title: 'Access Denied\nYou don\'t have permission for this action',
  buttonTitle: 'Go Back',
  onPressed: () => Navigator.pop(context),
)

// Account Suspended
CustomFailureWidget(
  title: 'Account Suspended\nContact support for assistance',
  buttonTitle: 'Contact Support',
  onPressed: () => SupportService.openSuspensionHelp(),
)
```

### Data State Errors
```dart
// Empty Search Results
CustomFailureWidget(
  title: 'No Results Found\nTry different search terms',
  buttonTitle: 'Clear Search',
  onPressed: () => SearchService.clearAndReset(),
)

// No Data Available
CustomFailureWidget(
  title: 'No Data Available\nCheck back later for updates',
  buttonTitle: 'Refresh',
  onPressed: () => DataService.forceRefresh(),
)

// Sync Failed
CustomFailureWidget(
  title: 'Sync Failed\nUnable to sync your data',
  buttonTitle: 'Try Sync',
  onPressed: () => SyncService.forceSyncRetry(),
)
```

## Testing

### Widget Tests
```dart
testWidgets('CustomFailureWidget displays title correctly', (tester) async {
  const testTitle = 'Test Error Message\nSecond Line';
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CustomFailureWidget(
          title: testTitle,
          onPressed: () {},
        ),
      ),
    ),
  );

  expect(find.text(testTitle), findsOneWidget);
});

testWidgets('CustomFailureWidget shows refresh icon when buttonTitle is null', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CustomFailureWidget(
          title: 'Error Message',
          // buttonTitle: null
          onPressed: () {},
        ),
      ),
    ),
  );

  expect(find.byIcon(Icons.refresh), findsOneWidget);
  expect(find.text('Refresh'), findsOneWidget);
});

testWidgets('CustomFailureWidget shows custom button text', (tester) async {
  const customButtonText = 'Try Again';
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CustomFailureWidget(
          title: 'Error Message',
          buttonTitle: customButtonText,
          onPressed: () {},
        ),
      ),
    ),
  );

  expect(find.text(customButtonText), findsOneWidget);
  expect(find.byIcon(Icons.refresh), findsNothing);
});

testWidgets('CustomFailureWidget calls onPressed when button tapped', (tester) async {
  bool wasPressed = false;
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CustomFailureWidget(
          title: 'Error Message',
          onPressed: () => wasPressed = true,
        ),
      ),
    ),
  );

  await tester.tap(find.text('Refresh'));
  expect(wasPressed, true);
});

testWidgets('CustomFailureWidget adapts to theme', (tester) async {
  // Test light theme
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        body: CustomFailureWidget(
          title: 'Error Message',
          onPressed: () {},
        ),
      ),
    ),
  );

  // Verify light theme styling
  final lightThemeText = tester.widget<Text>(find.text('Error Message'));
  // Add assertions for light theme colors

  // Test dark theme
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: CustomFailureWidget(
          title: 'Error Message',
          onPressed: () {},
        ),
      ),
    ),
  );

  // Verify dark theme styling
  final darkThemeText = tester.widget<Text>(find.text('Error Message'));
  // Add assertions for dark theme colors
});
```

### Integration Tests
```dart
group('CustomFailureWidget Integration Tests', () {
  testWidgets('Works with state management', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => TestBloc(),
          child: BlocBuilder<TestBloc, TestState>(
            builder: (context, state) {
              if (state is ErrorState) {
                return CustomFailureWidget(
                  title: state.errorMessage,
                  onPressed: () => context.read<TestBloc>().add(RetryEvent()),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );

    // Trigger error state
    // Test retry functionality
  });

  testWidgets('Integrates with navigation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CustomFailureWidget(
          title: 'Navigation Error',
          buttonTitle: 'Go Back',
          onPressed: () => Navigator.of(tester.element(find.byType(CustomFailureWidget)))
              .pop(),
        ),
        routes: {
          '/second': (context) => Scaffold(body: Text('Second Page')),
        },
      ),
    );

    // Test navigation behavior
    await tester.tap(find.text('Go Back'));
    await tester.pumpAndSettle();
  });
});
```

## Accessibility

### Screen Reader Support
```dart
Semantics(
  label: 'Error occurred',
  hint: 'Double tap the button to retry the action',
  child: CustomFailureWidget(
    title: 'Connection Error\nPlease try again',
    onPressed: () => retryAction(),
  ),
)
```

### High Contrast Support
```dart
class AccessibleCustomFailureWidget extends StatelessWidget {
  final String title;
  final String? buttonTitle;
  final VoidCallback? onPressed;

  const AccessibleCustomFailureWidget({
    required this.title,
    this.buttonTitle,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final highContrast = MediaQuery.of(context).highContrast;
    
    return CustomFailureWidget(
      title: title,
      buttonTitle: buttonTitle,
      onPressed: onPressed,
    );
    // Note: The widget should internally handle high contrast mode
  }
}
```

## Performance Considerations

### Memory Optimization
```dart
class OptimizedFailureScreen extends StatelessWidget {
  final Exception error;

  const OptimizedFailureScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    // Compute error message once
    final errorMessage = _computeErrorMessage(error);
    final buttonTitle = _computeButtonTitle(error);
    
    return CustomFailureWidget(
      title: errorMessage,
      buttonTitle: buttonTitle,
      onPressed: () => _handleRetry(),
    );
  }

  String _computeErrorMessage(Exception error) {
    // Expensive computation done once
    return ErrorMessageComputer.computeMessage(error);
  }

  String? _computeButtonTitle(Exception error) {
    // Compute button title based on error type
    return ErrorMessageComputer.computeButtonTitle(error);
  }

  void _handleRetry() {
    // Optimized retry logic
    ErrorRecoveryService.optimizedRetry(error);
  }
}
```

## Migration Guide

### From Generic Error Widgets
```dart
// Before - Generic error display
Container(
  child: Column(
    children: [
      Text('Error occurred'),
      ElevatedButton(
        onPressed: onRetry,
        child: Text('Retry'),
      ),
    ],
  ),
)

// After - Using CustomFailureWidget
CustomFailureWidget(
  title: 'Error occurred\nPlease try again',
  onPressed: onRetry,
)
```

### From AlertDialog Error Handling
```dart
// Before - Alert dialog for errors
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Error'),
    content: Text('Something went wrong'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('OK'),
      ),
    ],
  ),
);

// After - Full screen error with better UX
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => Scaffold(
      body: CustomFailureWidget(
        title: 'Something went wrong\nPlease try again',
        onPressed: () => Navigator.pop(context),
      ),
    ),
  ),
);
```

## Best Practices

### ✅ Do's
- Use clear, user-friendly error messages
- Provide actionable solutions when possible
- Keep titles concise but informative
- Use consistent error handling patterns across your app
- Test error states as thoroughly as success states

### ❌ Don'ts
- Don't show technical error details to end users
- Avoid overly long error messages
- Don't use the widget without an onPressed callback unless truly read-only
- Don't forget to test both light and dark theme appearances

### Error Message Guidelines
```dart
// ✅ Good - Clear and actionable
'No Internet Connection\nCheck your network and try again'

// ❌ Bad - Technical and unclear
'SocketException: Failed to connect to server'

// ✅ Good - User-friendly
'Unable to save changes\nPlease try again or contact support'

// ❌ Bad - Vague
'Error 500'
```

## Conclusion

`CustomFailureWidget` provides a polished, consistent way to handle error states across your Flutter application. Its theme-adaptive design, customizable button behavior, and responsive layout make it suitable for a wide variety of error scenarios. The widget's focus on user experience ensures that errors are presented in a friendly, actionable manner that encourages users to resolve issues and continue using your app.

### Key Benefits:
1. **Consistent Error UX**: Standardized error presentation across the app
2. **Theme Adaptive**: Automatic light/dark theme support
3. **Flexible Actions**: Default refresh or custom button text
4. **Responsive Design**: Proper scaling across device sizes
5. **Performance Optimized**: Lightweight StatelessWidget implementation

### Common Use Cases:
- Network connectivity errors
- Server/API failures  
- Authentication issues
- Empty data states
- Permission errors
- Sync failures
- Any scenario requiring user action after an error