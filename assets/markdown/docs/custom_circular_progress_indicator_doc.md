# CustomCircularProgressIndicator Documentation

## Overview

`CustomCircularProgressIndicator` is a Flutter widget that provides a visually enhanced loading indicator using Lottie animations instead of the standard Flutter circular progress indicator. This widget offers a more engaging user experience with smooth, custom animations.

## Widget Structure

```dart
class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.strokeWidth,
    this.valueColor,
    this.backgroundColor
  });
}
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `value` | `double?` | `null` | Progress value (0.0 to 1.0), null for indeterminate progress |
| `color` | `Color?` | `null` | Primary color (currently not applied due to Lottie usage) |
| `strokeWidth` | `double?` | `4` | Width of the progress indicator stroke (currently not applied) |
| `valueColor` | `Animation<Color?>?` | `null` | Animated color for the progress indicator |
| `backgroundColor` | `Color?` | `null` | Background color of the indicator |

## Features

### 🎨 **Lottie Animation**
- Uses custom Lottie animation for superior visual appeal
- Smooth, professional loading animations
- Better user engagement compared to standard indicators

### 📐 **Fixed Dimensions**
- Currently set to 50x50 pixels for consistency
- `BoxFit.fill` ensures animation fills the entire widget area
- Responsive design considerations with ScreenUtil integration

### 🎯 **Asset-Based**
- Uses `Assets.customLoading` animation file
- Centralized asset management
- Easy to replace with different animations

## Usage Examples

### Basic Indeterminate Loading
```dart
CustomCircularProgressIndicator()
```

### With Progress Value (Note: Currently ignored)
```dart
CustomCircularProgressIndicator(
  value: 0.7, // 70% progress
  color: AppColors.PRIMARY_COLOR,
)
```

### Custom Styling (Note: Currently limited)
```dart
CustomCircularProgressIndicator(
  strokeWidth: 6.0,
  backgroundColor: Colors.grey[200],
  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
)
```

### In Loading States
```dart
class LoadingExample extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingExample({
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CustomCircularProgressIndicator(),
          )
        : child;
  }
}
```

## Implementation Details

### Current Implementation
The widget currently uses a simplified approach:

```dart
@override
Widget build(BuildContext context) {
  return Lottie.asset(
    Assets.customLoading,
    width: 50,
    height: 50,
    fit: BoxFit.fill,
  );
}
```

### Legacy Code
The commented code shows the original `CircularProgressIndicator` implementation:

```dart
// CircularProgressIndicator(
//   color: color ?? AppColors.getButtonPrimaryWhiteColor(context),
//   value: value,
//   strokeWidth: strokeWidth ?? 4,
//   valueColor: valueColor,
//   backgroundColor: backgroundColor,
// );
```

## Customization Options

### Animation Asset
To change the loading animation:

1. Replace the asset file referenced by `Assets.customLoading`
2. Ensure the new animation is optimized for 50x50 pixel display
3. Test the animation loop behavior

### Size Variations
For different sizes, consider creating size-specific variants:

```dart
class CustomCircularProgressIndicator extends StatelessWidget {
  final double? size;
  
  const CustomCircularProgressIndicator({
    super.key,
    this.size,
    // ... other parameters
  });

  @override
  Widget build(BuildContext context) {
    final indicatorSize = size ?? 50.0;
    
    return Lottie.asset(
      Assets.customLoading,
      width: indicatorSize,
      height: indicatorSize,
      fit: BoxFit.fill,
    );
  }
}
```

## Best Practices

### 1. **Performance Considerations**
- Lottie animations can be resource-intensive
- Consider providing a fallback for low-end devices
- Cache animations when possible

```dart
// Example with fallback
Widget build(BuildContext context) {
  if (isLowEndDevice) {
    return CircularProgressIndicator(
      color: color ?? AppColors.getButtonPrimaryWhiteColor(context),
    );
  }
  
  return Lottie.asset(Assets.customLoading, width: 50, height: 50);
}
```

### 2. **Accessibility**
```dart
Semantics(
  label: 'Loading content, please wait',
  child: CustomCircularProgressIndicator(),
)
```

### 3. **Consistent Usage**
- Use consistently throughout the app for loading states
- Avoid mixing with standard CircularProgressIndicator
- Consider context-specific loading indicators for different features

## Integration Examples

### In Forms
```dart
ElevatedButton(
  onPressed: isSubmitting ? null : handleSubmit,
  child: isSubmitting
      ? const SizedBox(
          width: 20,
          height: 20,
          child: CustomCircularProgressIndicator(),
        )
      : const Text('Submit'),
)
```

### In Lists
```dart
ListView.builder(
  itemCount: items.length + (isLoadingMore ? 1 : 0),
  itemBuilder: (context, index) {
    if (index == items.length) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CustomCircularProgressIndicator(),
        ),
      );
    }
    return ListTile(title: Text(items[index]));
  },
)
```

### In Dialogs
```dart
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) => AlertDialog(
    content: Row(
      children: [
        const CustomCircularProgressIndicator(),
        const SizedBox(width: 16),
        Text('Processing...'),
      ],
    ),
  ),
);
```

## Troubleshooting

### Common Issues

1. **Animation Not Displaying**
   - Verify `Assets.customLoading` path is correct
   - Check if Lottie package is properly added to `pubspec.yaml`
   - Ensure animation file is included in assets

2. **Performance Issues**
   - Consider reducing animation complexity
   - Implement fallback for older devices
   - Use animation caching where appropriate

3. **Size Issues**
   - Current implementation uses fixed 50x50 size
   - Modify dimensions based on use case
   - Consider responsive sizing with ScreenUtil

### Debug Tips
```dart
// Add debug information
Widget build(BuildContext context) {
  debugPrint('CustomCircularProgressIndicator building');
  
  return Lottie.asset(
    Assets.customLoading,
    width: 50,
    height: 50,
    fit: BoxFit.fill,
    onLoaded: (composition) {
      debugPrint('Lottie animation loaded: ${composition.duration}');
    },
  );
}
```

## Future Enhancements

### Suggested Improvements

1. **Parameterized Sizing**
   ```dart
   final double width;
   final double height;
   ```

2. **Progress Value Support**
   ```dart
   // Implement progress-aware animation control
   if (value != null) {
     return Lottie.asset(
       Assets.customLoading,
       controller: animationController,
       width: 50,
       height: 50,
     );
   }
   ```

3. **Multiple Animation Variants**
   ```dart
   enum LoadingType { standard, fast, slow, pulse }
   final LoadingType type;
   ```

4. **Theme Integration**
   ```dart
   // Color customization for different themes
   ColorFilter? colorFilter;
   if (color != null) {
     colorFilter = ColorFilter.mode(color!, BlendMode.srcIn);
   }
   ```

## Dependencies

```yaml
dependencies:
  lottie: ^2.6.0
  flutter_screenutil: ^5.8.4
```

## Migration Guide

### From CircularProgressIndicator
```dart
// Before
CircularProgressIndicator(
  value: 0.5,
  color: Colors.blue,
  strokeWidth: 3.0,
)

// After
CustomCircularProgressIndicator(
  value: 0.5,        // Currently ignored
  color: Colors.blue, // Currently ignored
  strokeWidth: 3.0,  // Currently ignored
)
```

**Note**: Current implementation doesn't utilize most parameters. Consider the commented code for full parameter support.

## Conclusion

`CustomCircularProgressIndicator` provides an enhanced loading experience through Lottie animations. While the current implementation is simplified, it offers a solid foundation for creating engaging loading states throughout the application. Consider implementing the suggested enhancements for more flexibility and feature completeness.