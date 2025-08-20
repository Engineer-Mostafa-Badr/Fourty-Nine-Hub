# NetworkErrorScreen Documentation

## Overview

The `NetworkErrorScreen` is a comprehensive full-screen widget designed to handle network connectivity issues gracefully. It provides users with clear feedback about connection problems and offers an intuitive retry mechanism with visual feedback and haptic responses.

## Features

- **Full-Screen Experience**: Complete screen takeover for critical network issues
- **Visual Feedback**: Large, prominent wifi-off icon with circular background
- **Localized Content**: Uses easy_localization for multi-language support
- **Interactive Retry**: Button with haptic feedback and loading states
- **Theme Aware**: Adapts to light/dark themes automatically
- **Responsive Design**: Uses ScreenUtil for consistent sizing across devices
- **Professional Styling**: Clean, modern design with proper spacing and colors

## Widget Structure

```dart
class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key});
}
```

## Visual Components

### Icon Container
- **Size**: 120x120 logical pixels
- **Shape**: Circular with primary color background (10% opacity)
- **Icon**: `Icons.wifi_off_rounded` at 60sp size
- **Color**: Primary app color

### Content Layout
- **Title**: Large header text (24sp, bold)
- **Description**: Subtitle text (16sp, 70% opacity)
- **Button**: Elevated button with icon and text

## Usage Examples

### Basic Implementation
```dart
// Show when network is disconnected
if (!isConnected) {
  return const NetworkErrorScreen();
}
```

### With Navigation
```dart
// Navigate to error screen
Navigator.of(context).pushReplacement(
  MaterialPageRoute(
    builder: (context) => const NetworkErrorScreen(),
  ),
);
```

### Conditional Display
```dart
class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: connectivityService.isConnectedStream,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;
        
        if (!isConnected) {
          return const NetworkErrorScreen();
        }
        
        return const HomeScreen();
      },
    );
  }
}
```

## Retry Mechanism

### Button Functionality
The retry button performs the following actions:

```dart
onPressed: () {
  ManageVibration.vibrate(); // Haptic feedback
  NetworkManager().initialize(); // Reinitialize network manager
  NetworkManager().checkActualInternetAccess(); // Check connectivity
}
```

### User Experience Flow
1. User taps retry button
2. Haptic feedback provides immediate response
3. Network manager reinitializes
4. Actual internet access is verified
5. Screen automatically updates based on connection status

## Styling Details

### Colors
- **Icon Container**: Primary color with 10% opacity background
- **Icon**: Primary app color
- **Title**: Theme-aware text color
- **Description**: Theme-aware text color with 70% opacity
- **Button**: Primary color background with white text

### Typography
- **Title**: 24sp, bold weight, header text style
- **Description**: 16sp, medium weight, body text style
- **