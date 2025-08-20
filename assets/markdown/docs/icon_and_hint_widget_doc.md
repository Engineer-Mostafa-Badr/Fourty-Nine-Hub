# IconAndHintWidget Documentation

## Overview

The `IconAndHintWidget` is a versatile information display widget that combines an SVG alert icon with customizable text. It's designed for showing hints, warnings, alerts, or informational messages with consistent visual presentation and responsive text handling.

## Features

- **SVG Icon Integration**: Uses SVG assets for scalable, crisp icons
- **Flexible Text Display**: Supports multi-line text with line limits
- **Custom Styling**: Configurable text appearance and formatting  
- **Responsive Layout**: Proper text wrapping with icon alignment
- **Theme Awareness**: Automatic color adaptation for light/dark themes
- **Accessibility Ready**: Proper semantic structure for screen readers

## Widget Structure

```dart
class IconAndHintWidget extends StatelessWidget {
  const IconAndHintWidget({
    super.key,
    required this.text,
    this.textStyle,
  });

  final String text;
  final TextStyle? textStyle;
}
```

## Parameters

### Required Parameters
- **`text`**: The message content to display alongside the icon

### Optional Parameters  
- **`textStyle`**: Custom text styling (overrides default theme-aware styling)

## Visual Layout

### Component Structure
```dart
Row(
  children: [
    SvgPicture.asset(Assets.alertIcon), // Fixed icon
    SizedBox(width: 8),                 // Spacing
    Expanded(                           // Flexible text
      child: Label(
        text: text,
        maxLines: 2,
        style: textStyle ?? defaultStyle,
      ),
    )
  ],
)
```

### Default Styling
- **Icon**: SVG alert icon from `Assets.alertIcon`
- **Spacing**: 8px between icon and text
- **Text**: 20sp medium text, theme-aware colors
- **Max Lines**: 2 lines with ellipsis overflow
- **Layout**: Row with expanded text area

## Usage Examples

### Basic Usage
```dart
IconAndHintWidget(
  text: 'This is an important message for the user',
)
```

### With Custom Styling
```dart
IconAndHintWidget(
  text: 'Warning: Please verify your input',
  textStyle: TextStyle(
    fontSize: 18,
    color: Colors.orange,
    fontWeight: FontWeight.w600,
  ),
)
```

### In Forms
```dart
Column(
  children: [
    TextFormField(
      // form field
    ),
    SizedBox(height: 8),
    IconAndHintWidget(
      text: 'Password must contain at least 8 characters',
      textStyle: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      ),
    ),
  ],
)
```

### As Validation Messages
```dart
if (hasError)
  IconAndHintWidget(
    text: errorMessage,
    textStyle: TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w500,
    ),
  )
```

## Common Use Cases

### 1. Form Validation
Display field-specific guidance or error messages:

```dart
class ValidatedTextField extends StatefulWidget {
  @override
  _ValidatedTextFieldState createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField> {
  String? errorText;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onChanged: validateInput,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: errorText,
          ),
        ),
        if (errorText == null)
          IconAndHintWidget(
            text: 'Enter a valid email address',
            textStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
      ],
    );
  }
}
```

### 2. Information Panels
Show contextual information or tips:

```dart
class InfoPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: IconAndHintWidget(
          text: 'Tip: Save frequently to prevent data loss',
          textStyle: TextStyle(
            color: Colors.blue[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
```

### 3. Warning Messages
Display important alerts or warnings:

```dart
class WarningBanner extends StatelessWidget {
  final String message;
  
  const WarningBanner({super.key, required this.message});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: IconAndHintWidget(
        text: message,
        textStyle: TextStyle(
          color: Colors.orange[800],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
```

### 4. Status Messages
Communicate system or operation status:

```dart
class StatusWidget extends StatelessWidget {
  final String status;
  final StatusType type;
  
  @override
  Widget build(BuildContext context) {
    Color getStatusColor() {
      switch (type) {
        case StatusType.success:
          return Colors.green[700]!;
        case StatusType.warning:
          return Colors.orange[700]!;
        case StatusType.error:
          return Colors.red[700]!;
        default:
          return Colors.blue[700]!;
      }
    }
    
    return IconAndHintWidget(
      text: status,
      textStyle: TextStyle(
        color: getStatusColor(),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
```

## Styling Guidelines

### Text Styling Best Practices

#### Information Messages
```dart
TextStyle(
  fontSize: 16,
  color: Colors.blue[700],
  fontWeight: FontWeight.normal,
)
```

#### Warning Messages
```dart
TextStyle(
  fontSize: 16,
  color: Colors.orange[700],
  fontWeight: FontWeight.w500,
)
```

#### Error Messages
```dart
TextStyle(
  fontSize: 16,
  color: Colors.red[700],
  fontWeight: FontWeight.w600,
)
```

#### Success Messages
```dart
TextStyle(
  fontSize: 16,
  color: Colors.green[700],
  fontWeight: FontWeight.w500,
)
```

## Theme Integration

### Automatic Color Adaptation
The widget automatically adapts to theme changes:

```dart
// Default text style adapts to theme
style: textStyle ?? Styles.mediumText(
  fontSize: 20,
  color: context.isDarkMode ? Colors.white : Colors.black,
)
```

### Custom Theme Colors
```dart
class ThemedIconAndHint extends StatelessWidget {
  final String text;
  final MessageType type;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Color getThemedColor() {
      switch (type) {
        case MessageType.primary:
          return theme.primaryColor;
        case MessageType.secondary:
          return theme.colorScheme.secondary;
        case MessageType.error:
          return theme.errorColor;
        default:
          return theme.textTheme.bodyLarge?.color ?? Colors.black;
      }
    }
    
    return IconAndHintWidget(
      text: text,
      textStyle: TextStyle(
        color: getThemedColor(),
        fontSize: 16,
      ),
    );
  }
}
```

## Asset Management

### SVG Icon Requirements
The widget depends on SVG assets:

```dart
// Ensure this asset exists in your project
Assets.alertIcon // Path to your alert icon SVG
```

### Custom Icons
To use different icons, extend the widget:

```dart
class CustomIconHintWidget extends StatelessWidget {
  final String text;
  final String iconAsset;
  final TextStyle? textStyle;
  
  const CustomIconHintWidget({
    super.key,
    required this.text,
    required this.iconAsset,
    this.textStyle,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(iconAsset),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textStyle ?? DefaultTextStyle.of(context).style,
          ),
        ),
      ],
    );
  }
}
```

## Accessibility Features

### Screen Reader Support
The widget provides proper semantic structure:

```dart
// Enhance with semantics when needed
Semantics(
  label: 'Important information',
  child: IconAndHintWidget(
    text: 'Your data will be saved automatically',
  ),
)
```

### Contrast and Readability
- Uses theme-aware colors for proper contrast
- Respects system text scaling
- Maintains readability in both light and dark themes

### Touch Accessibility
- No interactive elements, so no touch target requirements
- Text scales with system font size settings

## Performance Considerations

### Efficient Rendering
- Uses `Expanded` widget for optimal layout performance
- SVG icons are cached automatically by flutter_svg
- Minimal widget tree depth for fast rendering

### Memory Management
- SVG assets are loaded once and cached
- Text rendering is optimized by Flutter's text engine
- No unnecessary rebuilds due to StatelessWidget design

## Testing

### Unit Tests
```dart
testWidgets('IconAndHintWidget displays text correctly', (tester) async {
  const testText = 'Test message';
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: IconAndHintWidget(text: testText),
      ),
    ),
  );
  
  expect(find.text(testText), findsOneWidget);
  expect(find.byType(SvgPicture), findsOneWidget);
});
```

### Custom Style Tests
```dart
testWidgets('IconAndHintWidget applies custom style', (tester) async {
  const customStyle = TextStyle(color: Colors.red, fontSize: 24);
  
  await tester.pumpWidget(
    MaterialApp(
      home: IconAndHintWidget(
        text: 'Styled text',
        textStyle: customStyle,
      ),
    ),
  );
  
  final textWidget = tester.widget<Text>(find.byType(Text));
  expect(textWidget.style?.color, Colors.red);
  expect(textWidget.style?.fontSize, 24);
});
```

## Common Issues and Solutions

### Icon Not Displaying
**Problem**: SVG icon doesn't appear
**Solution**: Verify asset path and add to pubspec.yaml:

```yaml
flutter:
  assets:
    - assets/icons/
```

### Text Overflow
**Problem**: Long text doesn't display properly
**Solution**: The widget already handles this with `maxLines: 2` and ellipsis

### Theme Colors Not Working
**Problem**: Colors don't adapt to theme changes
**Solution**: Ensure proper theme context and use theme-aware colors:

```dart
IconAndHintWidget(
  text: 'Message',
  textStyle: TextStyle(
    color: Theme.of(context).textTheme.bodyLarge?.color,
  ),
)
```

## Migration and Upgrades

### From Basic Text Widgets
```dart
// Before
Row(
  children: [
    Icon(Icons.info),
    Text('Information message'),
  ],
)

// After
IconAndHintWidget(
  text: 'Information message',
)
```

### Adding Custom Styling
```dart
// Upgrade existing usage
IconAndHintWidget(
  text: existingText,
  textStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.blue[700],
  ),
)
```

## Extension Possibilities

### Multi-Icon Support
```dart
class MultiIconHintWidget extends StatelessWidget {
  final String text;
  final List<String> iconAssets;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...iconAssets.map((asset) => Padding(
          padding: EdgeInsets.only(right: 4),
          child: SvgPicture.asset(asset, width: 16, height: 16),
        )),
        SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}
```

### Action Integration
```dart
class ActionableIconHint extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IconAndHintWidget(text: text),
    );
  }
}
```

## Dependencies

### Required Packages
- `flutter/material.dart`: Core Flutter widgets
- `flutter_svg/svg.dart`: SVG rendering support
- App-specific label widget and styling system

### Asset Dependencies
- SVG icon file at specified asset path
- Proper asset configuration in pubspec.yaml

## Best Practices Summary

1. **Consistent Messaging**: Use for similar types of information throughout your app
2. **Appropriate Styling**: Match text style to message importance and type
3. **Asset Management**: Ensure SVG icons are optimized and properly referenced
4. **Theme Integration**: Leverage theme-aware colors for consistent appearance
5. **Accessibility**: Consider screen reader users and text scaling
6. **Performance**: Use efficiently with minimal nesting and proper keys when needed