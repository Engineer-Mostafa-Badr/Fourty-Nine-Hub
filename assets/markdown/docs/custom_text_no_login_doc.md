# CustomTextNoLogin Documentation

## Overview

The `CustomTextNoLogin` widget collection provides multiple variations of user authentication prompts. These widgets are designed to encourage user registration or login when accessing features that require authentication, with different visual styles ranging from circular designs to progress indicators.

## Widget Variants

### 1. CustomTextNoLogin (Original)
A circular container design with prominent messaging.

### 2. CustomTextNoLoginNew 
A simplified text-only approach with large, attention-grabbing typography.

### 3. CustomNotLogged
A sophisticated design combining circular progress indicators with centered text.

## Features

- **Multiple Design Options**: Choose from circular, text-only, or progress-enhanced designs
- **Interactive Elements**: Tap-to-action functionality with haptic feedback
- **Theme Awareness**: Adapts to light/dark themes automatically
- **Localized Content**: Supports internationalization
- **Responsive Sizing**: Uses ScreenUtil for consistent cross-device experience
- **Progress Visualization**: Optional progress indicator for engagement

## Widget Structures

### CustomTextNoLogin
```dart
class CustomTextNoLogin extends StatelessWidget {
  const CustomTextNoLogin({super.key});
}
```

### CustomTextNoLoginNew  
```dart
class CustomTextNoLoginNew extends StatelessWidget {
  const CustomTextNoLoginNew({super.key});
}
```

### CustomNotLogged
```dart
class CustomNotLogged extends StatelessWidget {
  const CustomNotLogged({super.key});
}
```

## Visual Specifications

### CustomTextNoLogin (Original)
- **Container**: 500w × 500h circular shape
- **Background**: Theme primary color
- **Border**: 4px solid border in primary color
- **Text**: Bold header style, scaffold background color
- **Padding**: 12w internal padding

### CustomTextNoLoginNew
- **Text Size**: 50sp (configurable via Styles.headerText)
- **Color**: Theme primary color
- **Weight**: Bold
- **Alignment**: Center
- **Layout**: Simple centered text

### CustomNotLogged
- **Container**: Fixed 300×300 size
- **Progress Indicator**: 20 total steps, 15 current steps
- **Step Size**: 20px per step
- **Colors**: Primary color (selected), Grey (unselected)
- **Center Content**: CustomTextNoLoginNew widget

## Usage Examples

### Basic Implementation
```dart
// Simple circular design
const CustomTextNoLogin()

// Modern text-only design
const CustomTextNoLoginNew()

// Progress-enhanced design
const CustomNotLogged()
```

### Conditional Display
```dart
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthProvider>().isAuthenticated;
    
    if (!isLoggedIn) {
      return const CustomNotLogged();
    }
    
    return const AuthenticatedContent();
  }
}
```

### In Page Layouts
```dart
class ProtectedFeatureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Protected Feature')),
      body: AuthService.isLoggedIn
        ? const FeatureContent()
        : const CustomTextNoLoginNew(),
    );
  }
}
```

## Interactive Behavior

### Tap Handling
All variants include tap gesture handling:

```dart
GestureDetector(
  onTap: () {
    ManageVibration.vibrate(); // Haptic feedback
    return pleaseLoginDialog(context); // Show login dialog
  },
  child: // Widget content
)
```

### User Flow
1. User taps on any login prompt widget
2. Haptic feedback provides immediate response
3. Login dialog appears (via `pleaseLoginDialog`)
4. User can authenticate or register
5. Screen updates based on authentication state

## Localization Support

### Localization Keys
The widgets use the following keys:

```dart
LocaleKeys.loginOrRegister.localize // "Register/Login \n To enjoy App"
```

### Adding Translations
Update your localization files:

```json
{
  "loginOrRegister": "Register/Login \n To enjoy App",
  "pleaseLogin": "Please Login, Register to enjoy the app"
}
```

## Styling Customization

### Theme Integration
Colors automatically adapt:
- **Light Theme**: Primary color text/containers
- **Dark Theme**: Maintains contrast and readability
- **Background**: Uses theme scaffold background

### Custom Styling
```dart
// Override default styling
Text(
  'Custom login message',
  style: Styles.headerText(
    fontSize: 40, // Custom size
    color: Colors.blue, // Custom color
  ),
)
```

## Progress Indicator Configuration

### CircularStepProgressIndicator Properties
```dart
CircularStepProgressIndicator(
  totalSteps: 20,        // Total number of steps
  currentStep: 15,       // Current progress (75%)
  stepSize: 20,          // Size of each step
  selectedStepSize: 20,  // Size of completed steps
  width: 300,            // Overall width
  height: 300,           // Overall height
  padding: 0.5,          // Step padding
  selectedColor: AppColors.PRIMARY_COLOR,
  unselectedColor: Colors.grey,
)
```

### Customizing Progress
```dart
class CustomProgressLogin extends StatelessWidget {
  final int userProgress;
  
  const CustomProgressLogin({
    super.key,
    this.userProgress = 15,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularStepProgressIndicator(
            totalSteps: 20,
            currentStep: userProgress,
            // ... other properties
          ),
          const CustomTextNoLoginNew(),
        ],
      ),
    );
  }
}
```

## Best Practices

### When to Use Each Variant

#### CustomTextNoLogin (Original)
- **Use for**: Traditional apps, formal interfaces
- **Pros**: Eye-catching, professional appearance
- **Cons**: Takes more screen space

#### CustomTextNoLoginNew
- **Use for**: Modern apps, minimal interfaces  
- **Pros**: Clean, lightweight, fast loading
- **Cons**: Less visual impact

#### CustomNotLogged
- **Use for**: Gamified apps, progress-oriented features
- **Pros**: Engaging, shows completion status
- **Cons**: More complex, requires progress logic

### UX Considerations
1. **Clear Messaging**: Make authentication benefits obvious
2. **Easy Access**: Prominent placement and easy interaction
3. **Progress Feedback**: Show what users gain by authenticating
4. **Consistent Placement**: Use same variant throughout app

### Accessibility

#### Screen Reader Support
```dart
Semantics(
  label: 'Login required to access this feature',
  hint: 'Tap to open login dialog',
  child: CustomTextNoLogin(),
)
```

#### Touch Targets
- Ensure minimum 48×48dp touch areas
- CustomTextNoLogin naturally provides large touch target
- Add padding around other variants if needed

## Integration Patterns

### With Authentication Provider
```dart
class AuthGate extends StatelessWidget {
  final Widget child;
  final Widget? loginPrompt;
  
  const AuthGate({
    super.key,
    required this.child,
    this.loginPrompt,
  });
  
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isAuthenticated) {
          return child;
        }
        
        return loginPrompt ?? const CustomNotLogged();
      },
    );
  }
}
```

### With Navigation
```dart
class RouteGuard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const AuthenticatedApp();
        }
        
        return Scaffold(
          body: const CustomTextNoLoginNew(),
        );
      },
    );
  }
}
```

## Dependencies

### Required Packages
- `flutter/material.dart`: Core Flutter widgets
- `flutter_screenutil`: Responsive sizing
- `step_progress_indicator`: Circular progress visualization
- `fourtyninehub/helpers/manage_vibration.dart`: Haptic feedback

### App-Specific Dependencies
- `AppColors`: Application color scheme
- `Styles`: Typography and styling constants
- `LocaleKeys`: Internationalization keys
- `pleaseLoginDialog`: Authentication dialog function

## Performance Considerations

- **Lightweight Widgets**: Minimal computational overhead
- **Efficient Rendering**: Simple layouts with good performance
- **Memory Usage**: Small memory footprint
- **Animation**: No complex animations affecting performance

## Testing

### Widget Tests
```dart
testWidgets('CustomTextNoLogin triggers login dialog', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: CustomTextNoLogin()),
  );
  
  await tester.tap(find.byType(CustomTextNoLogin));
  await tester.pumpAndSettle();
  
  // Verify dialog appears
  expect(find.text('Login'), findsOneWidget);
});
```

### Integration Tests
```dart
testWidgets('Login flow integration', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Navigate to protected screen
  await tester.tap(find.text('Protected Feature'));
  await tester.pumpAndSettle();
  
  // Should show login prompt
  expect(find.byType(CustomNotLogged), findsOneWidget);
  
  // Tap login prompt
  await tester.tap(find.byType(CustomNotLogged));
  await tester.pumpAndSettle();
  
  // Verify login dialog
  expect(find.text('Login'), findsOneWidget);
});
```

## Common Issues

### Layout Overflow
When text is too long:
```dart
// Add flexible wrapping
Flexible(
  child: CustomTextNoLoginNew(),
)
```

### Theme Context
Ensure widgets have proper theme context:
```dart
// Wrap with Material if needed
Material(
  child: CustomTextNoLogin(),
)
```

### Progress Synchronization
Keep progress indicators in sync:
```dart
class ProgressManager {
  static int calculateUserProgress(User user) {
    // Logic to determine user completion percentage
    return (user.completedSteps / user.totalSteps * 20).round();
  }
}
```