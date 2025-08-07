# CallMessageButtons Widget Documentation

## Overview

`CallMessageButtons` is a Flutter widget that provides call and messaging functionality buttons for user interactions. It includes call, chat, and optional report buttons with dynamic availability based on user authentication and subscription status.

## Widget Structure

```dart
class CallMessageButtons extends StatefulWidget {
  const CallMessageButtons({
    super.key,
    required this.otherUserId,
    required this.subcategoryId,
    required this.phone,
    this.senderName,
    this.senderImage,
    required this.id,
    this.hasReport = false,
    this.flex,
    this.chatFlex,
    this.clientId
  });
}
```

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `otherUserId` | `String` | The ID of the other user to interact with |
| `subcategoryId` | `String` | The subcategory ID for the interaction |
| `phone` | `String` | Phone number for calling functionality |
| `id` | `String` | Unique identifier for the interaction |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `clientId` | `String?` | `null` | Optional client identifier |
| `senderName` | `String?` | `null` | Name of the sender/user |
| `senderImage` | `String?` | `null` | Profile image URL of the sender |
| `hasReport` | `bool?` | `false` | Whether to show the report button |
| `flex` | `int?` | `3` | Flex value for the call button |
| `chatFlex` | `int?` | `3` | Flex value for the chat button |

## Features

### 1. Call Functionality
- **Service Call**: Direct phone call using the provided phone number
- **Premium Call**: Video/Audio call with advanced features
- Requires microphone and camera permissions for premium calls
- Shows different UI based on user subscription status

### 2. Chat Functionality
- Creates or navigates to existing chat with the other user
- Integrates with the app's chat system
- Requires user authentication

### 3. Report Functionality
- Optional report button for content moderation
- Only shown when `hasReport` is `true`
- Requires user authentication

### 4. Dynamic Button States
- Buttons change appearance based on:
  - User authentication status
  - Subscription/availability status
  - Dark/Light theme mode

## Button States

### Enabled State
- **Color**: `AppColors.SECONDARY_COLOR`
- **Functionality**: Full functionality available
- **Requirements**: User logged in and has access

### Disabled State
- **Color**: `AppColors.DARK_GRAY_COLOR` or theme-based color
- **Functionality**: Shows subscription prompt
- **Requirements**: User not subscribed or not logged in

## Usage Examples

### Basic Usage
```dart
CallMessageButtons(
  otherUserId: 'user123',
  subcategoryId: 'subcat456',
  phone: '+1234567890',
  id: 'interaction001',
  senderName: 'John Doe',
)
```

### With Custom Flex Values
```dart
CallMessageButtons(
  otherUserId: 'user123',
  subcategoryId: 'subcat456',
  phone: '+1234567890',
  id: 'interaction001',
  senderName: 'John Doe',
  flex: 2,          // Call button takes 2 parts
  chatFlex: 4,      // Chat button takes 4 parts
  hasReport: true,  // Show report button
)
```

### Complete Configuration
```dart
CallMessageButtons(
  otherUserId: 'user123',
  clientId: 'client456',
  subcategoryId: 'subcat789',
  phone: '+1234567890',
  id: 'interaction001',
  senderName: 'John Doe',
  senderImage: 'https://example.com/avatar.jpg',
  hasReport: true,
  flex: 3,
  chatFlex: 3,
)
```

## Dependencies

The widget depends on several external packages and internal modules:

### External Packages
- `flutter_bloc`: State management
- `flutter_screenutil`: Screen adaptation
- `flutter_svg`: SVG icon support
- `go_router`: Navigation
- `permission_handler`: Runtime permissions

### Internal Dependencies
- `ButtonAvailability`: Checks button availability
- `UserCubit`: User authentication state
- `LaunchURLHelper`: Phone call functionality
- `FcmNotificationHelper`: Push notifications
- `SubscriptionMethod`: Subscription management

## Permissions Required

### For Premium Calls
- **Microphone**: Required for audio calls
- **Camera**: Required for video calls

The widget automatically requests these permissions when needed.

## Theming Support

The widget supports both light and dark themes:

### Light Theme
- Uses standard app colors
- Icons use default colors or theme-specific colors

### Dark Theme
- Icons use white color when disabled
- Background colors adapt to dark theme

## Localization

The widget supports multiple languages:
- Arabic and English text for call options
- Uses `context.isArabic` for language detection
- Integrates with the app's localization system

## Error Handling

### Permission Denied
- Requests permissions again if denied
- Continues with call attempt

### Network Issues
- Handled by underlying chat and call systems
- User feedback through standard app mechanisms

### Authentication Issues
- Shows login dialog for unauthenticated users
- Redirects to subscription flow when needed

## Customization Options

### Button Layout
- Adjust `flex` and `chatFlex` for different button sizes
- Control report button visibility with `hasReport`

### Visual Appearance
- Automatically adapts to app theme
- Uses app-wide color scheme
- Responsive design with ScreenUtil

## Integration Notes

### State Management
- Uses `BlocProvider` for state management
- Integrates with `UserCubit` for authentication
- Uses `AdvertisementCubit` for subscription status

### Navigation
- Uses `go_router` for navigation
- Supports both push and modal presentations
- Handles deep linking scenarios

### Performance
- Uses `FutureBuilder` for async button availability
- Efficient state updates through BLoC pattern
- Minimal rebuilds with proper state management

## Best Practices

1. **Always provide required parameters** for proper functionality
2. **Handle authentication states** appropriately in your app
3. **Test with different user states** (logged in, logged out, subscribed, etc.)
4. **Consider accessibility** when customizing flex values
5. **Test on different screen sizes** due to responsive design

## Troubleshooting

### Buttons Not Working
- Check user authentication status
- Verify subscription status
- Ensure required permissions are granted

### UI Issues
- Verify ScreenUtil is properly initialized
- Check theme configuration
- Ensure proper flex values are provided

### Call/Chat Not Opening
- Verify user IDs are correct
- Check network connectivity
- Ensure proper navigation setup