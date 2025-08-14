# CustomSwitchButton Documentation

## Overview

The `CustomSwitchButton` is an enhanced version of Flutter's standard Switch widget, featuring theme-aware styling, custom sizing, and intelligent color management. It automatically adapts its appearance based on the app's theme (dark/light mode) while providing consistent visual feedback.

## Features

- **Theme Awareness**: Automatically adapts colors based on `context.isDarkMode`
- **Custom Scaling**: Scaled to 0.7x by default for compact layouts
- **Intelligent Colors**: Smart thumb and track color selection
- **State-Dependent Styling**: Different colors for ON/OFF states
- **Customizable Properties**: Override default colors when needed
- **Zero Padding**: Optimized spacing for tight layouts

## Widget Structure

```dart
class CustomSwitchButton extends StatelessWidget {
  const CustomSwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.trackColor,
    this.trackOutlineColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
  });
  
  final bool value;
  final void Function(bool)? onChanged;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final WidgetStateProperty<Color?>? trackColor;
  final WidgetStateProperty<Color?>? trackOutlineColor;
  final WidgetStateProperty<Color?>? thumbColor;
}
```

## Color Logic

### Thumb Colors
The thumb color changes based on state and theme:

```dart
thumbColor ?? WidgetStatePropertyAll(
  value 
    ? context.isDarkMode ? Color(0xff0D0D0D) : Colors.white
    : context.isDarkMode ? Colors.white : Color(0xff0D0D0D)
)
```

**Color Matrix:**
- **ON + Light Mode**: White thumb
- **ON + Dark Mode**: Dark (0xff0D0D0D) thumb  
- **OFF + Light Mode**: Dark (0xff0D0D0D) thumb
- **OFF + Dark Mode**: White thumb

### Track Colors
Track colors provide clear visual feedback:

```dart
// Active (ON state)
activeTrackColor ?? (context.isDarkMode ? Colors.white : Colors.black)

// Inactive (OFF state)  
inactiveTrackColor: context.isDarkMode ? Color(0xff333333) : Color(0xffD9D9D9)
```

## Usage Examples

### Basic Usage
```dart
CustomSwitchButton(
  value: isEnabled,
  onChanged: (value) {
    setState(() {
      isEnabled = value;
    });
  },
)
```

### With Custom Colors
```dart
CustomSwitchButton(
  value: isEnabled,
  onChanged: (value) => updateSetting(value),
  activeTrackColor: Colors.green,
  thumbColor: const WidgetStatePropertyAll(Colors.white),
)
```

### Disabled State
```dart
CustomSwitchButton(
  value: currentValue,
  onChanged: null, // Disables the switch
)
```

### In Forms and Settings
```dart
ListTile(
  title: const Text('Enable Notifications'),
  trailing: CustomSwitchButton(
    value: notificationsEnabled,
    onChanged: (value) {
      setState(() {
        notificationsEnabled = value;
      });
      saveSettings();
    },
  ),
)
```

## Styling Properties

### Scale Transformation
The widget applies a default scale of 0.7:

```dart
Transform.scale(
  scale: .7,
  child: Switch(/* switch properties */),
)
```

### Track Outline
- **Width**: 1px outline
- **Color**: Transparent when active, themed when inactive

### Padding
- **Switch Padding**: `EdgeInsets.zero` for compact layouts

## Theme Integration

### Context Extension Usage
The widget relies on a context extension for theme detection:

```dart
context.isDarkMode // Returns true for dark theme
```

### Automatic Adaptation
Colors automatically switch when the app theme changes:
- No manual color management needed
- Consistent appearance across theme switches
- Maintains contrast and readability

## Best Practices

### When to Use
1. **Settings Screens**: Perfect for on/off toggles
2. **Form Controls**: Binary input options
3. **Feature Toggles**: Enable/disable functionality
4. **Compact Layouts**: Where standard switches are too large

### Accessibility Guidelines
1. **Semantic Labels**: Provide clear labels for screen readers
2. **State Announcement**: Ensure state changes are announced
3. **Touch Targets**: Maintain adequate touch target size despite scaling

### Performance Tips
1. **Avoid Frequent Rebuilds**: Use efficient state management
2. **Callback Optimization**: Keep onChanged callbacks lightweight
3. **Theme Listening**: Don't manually listen for theme changes

## Integration Examples

### With Provider/Bloc
```dart
class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return CustomSwitchButton(
          value: settings.isDarkMode,
          onChanged: settings.toggleDarkMode,
        );
      },
    );
  }
}
```

### With Form Validation
```dart
class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  bool agreedToTerms = false;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomSwitchButton(
              value: agreedToTerms,
              onChanged: (value) {
                setState(() {
                  agreedToTerms = value;
                });
              },
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('I agree to the terms and conditions'),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: agreedToTerms ? submitForm : null,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
```

## Customization Options

### Custom Scale
```dart
Transform.scale(
  scale: 1.0, // Full size
  child: CustomSwitchButton(
    value: value,
    onChanged: onChanged,
  ),
)
```

### Brand Colors
```dart
CustomSwitchButton(
  value: value,
  onChanged: onChanged,
  activeTrackColor: MyApp.brandColor,
  thumbColor: const WidgetStatePropertyAll(Colors.white),
)
```

### State-Specific Styling
```dart
CustomSwitchButton(
  value: value,
  onChanged: onChanged,
  thumbColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
      return Colors.blue;
    }
    return Colors.grey;
  }),
)
```

## Testing Considerations

### Widget Tests
```dart
testWidgets('CustomSwitchButton responds to tap', (tester) async {
  bool value = false;
  
  await tester.pumpWidget(
    MaterialApp(
      home: CustomSwitchButton(
        value: value,
        onChanged: (newValue) { value = newValue; },
      ),
    ),
  );
  
  await tester.tap(find.byType(CustomSwitchButton));
  expect(value, true);
});
```

### Theme Testing
```dart
testWidgets('CustomSwitchButton adapts to theme', (tester) async {
  // Test with light theme
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.light(),
      home: CustomSwitchButton(value: true, onChanged: (_) {}),
    ),
  );
  
  // Verify light theme colors
  
  // Test with dark theme
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.dark(),
      home: CustomSwitchButton(value: true, onChanged: (_) {}),
    ),
  );
  
  // Verify dark theme colors
});
```

## Common Issues

### Theme Detection
Ensure your app provides the context extension:
```dart
extension ThemeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
```

### Color Inheritance
When colors don't apply correctly, check:
- Widget is wrapped in Material/MaterialApp
- Theme is properly configured
- Context extension is available

### Touch Target Size
Despite 0.7x scaling, ensure adequate touch targets:
- Minimum 48x48 dp interactive area
- Add padding to parent container if needed
- Test with accessibility tools

## Migration Guide

### From Standard Switch
```dart
// Before
Switch(
  value: value,
  onChanged: onChanged,
)

// After
CustomSwitchButton(
  value: value,
  onChanged: onChanged,
)
```

### Maintaining Custom Colors
```dart
// Before
Switch(
  value: value,
  onChanged: onChanged,
  activeColor: Colors.green,
)

// After
CustomSwitchButton(
  value: value,
  onChanged: onChanged,
  activeTrackColor: Colors.green,
)
```