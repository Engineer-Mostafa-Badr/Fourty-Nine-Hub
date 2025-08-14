# NetworkAlertBanner Documentation

## Overview

The `NetworkAlertBanner` is a simple yet effective widget designed to inform users about network connectivity issues. It automatically shows or hides based on the connection status, providing a clean and unobtrusive way to communicate network problems.

## Features

- **Automatic Visibility**: Shows only when `isConnected` is false
- **Full Width Display**: Spans the entire width of its container
- **Localized Messages**: Uses easy_localization for international support
- **Theme Integration**: Uses app colors for consistent styling
- **Minimal UI Impact**: Collapses to nothing when not needed

## Widget Structure

```dart
class NetworkAlertBanner extends StatelessWidget {
  final bool isConnected;
  
  const NetworkAlertBanner({required this.isConnected, super.key});
}
```

## Parameters

### Required Parameters

- **`isConnected`**: Boolean indicating network connectivity status
  - `true`: Banner is hidden (SizedBox.shrink())
  - `false`: Banner is displayed with warning message

## Usage Examples

### Basic Implementation
```dart
NetworkAlertBanner(
  isConnected: networkStatus.isConnected,
)
```

### In App Layout
```dart
Column(
  children: [
    NetworkAlertBanner(isConnected: isConnected),
    // Rest of your app content
    Expanded(child: MainContent()),
  ],
)
```

### With Stream/Provider
```dart
StreamBuilder<bool>(
  stream: connectivityService.connectionStream,
  builder: (context, snapshot) {
    final isConnected = snapshot.data ?? true;
    return NetworkAlertBanner(isConnected: isConnected);
  },
)
```

## Styling Details

### Colors
- **Background**: `AppColors.PRIMARY_COLOR_DARK`
- **Text**: White with bold font weight

### Layout
- **Padding**: 10px all around
- **Width**: Full width (double.infinity)
- **Text Alignment**: Center

## Implementation Details

### Conditional Rendering
The widget uses a simple conditional that returns `SizedBox.shrink()` when connected:

```dart
@override
Widget build(BuildContext context) {
  if (isConnected) return const SizedBox.shrink();
  
  return Container(
    // Banner content
  );
}
```

### Localization
Uses `easy_localization` package:
```dart
Text(LocaleKeys.noInternetConnection.tr())
```

## Best Practices

### Positioning
1. **Top of Screen**: Most common placement for network alerts
2. **Above Content**: Pushes content down rather than overlaying
3. **Sticky Position**: Consider making it stick to top during scroll

### Animation
While not built-in, consider wrapping with AnimatedSwitcher:
```dart
AnimatedSwitcher(
  duration: Duration(milliseconds: 300),
  child: NetworkAlertBanner(isConnected: isConnected),
)
```

### Integration
- Connect to actual network monitoring service
- Update state based on real connectivity changes
- Consider showing different messages for different connection types

## Common Use Cases

### 1. App-Wide Network Monitoring
Place at the root level of your app:
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(
        children: [
          Consumer<NetworkProvider>(
            builder: (context, network, child) => 
              NetworkAlertBanner(isConnected: network.isConnected),
          ),
          Expanded(child: MainScreen()),
        ],
      ),
    );
  }
}
```

### 2. Screen-Specific Alerts
Show on screens that require internet:
```dart
class DataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NetworkAlertBanner(isConnected: context.watch<NetworkService>().isOnline),
          // Screen content
        ],
      ),
    );
  }
}
```

### 3. Form Submission Warnings
Alert before important actions:
```dart
Widget buildSubmitForm() {
  return Column(
    children: [
      if (!isConnected) 
        NetworkAlertBanner(isConnected: false),
      // Form fields
      ElevatedButton(
        onPressed: isConnected ? submitForm : null,
        child: Text('Submit'),
      ),
    ],
  );
}
```

## Accessibility

### Screen Readers
- Ensure the banner message is announced when it appears
- Consider using semantic labels for better context

### Color Contrast
- Default styling provides good contrast with white text on dark background
- Test with different accessibility tools

## Dependencies

- `easy_localization`: For internationalization support
- `flutter/material.dart`: Core Flutter widgets
- App-specific color constants (`AppColors.PRIMARY_COLOR_DARK`)

## Customization Options

While the widget is designed to be simple, you can extend it by:

1. **Custom Messages**: Modify localization keys
2. **Different Colors**: Pass custom colors as parameters
3. **Icons**: Add warning or wifi icons
4. **Actions**: Include retry buttons or settings links

## Performance Considerations

- Very lightweight widget with minimal rendering cost
- Uses `SizedBox.shrink()` for efficient hiding
- No animations or complex layouts that could impact performance
- Suitable for frequent state changes without performance issues