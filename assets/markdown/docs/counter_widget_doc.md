# CounterWidget Documentation

## Overview

`CounterWidget` is a Flutter widget that displays numerical values in a circular badge format with automatic number formatting. It intelligently formats large numbers using suffixes (K, M, B) and provides extensive customization options for appearance and styling.

## Widget Structure

```dart
class CounterWidget extends StatelessWidget {
  const CounterWidget({
    super.key,
    required this.unreadCount,
    this.width,
    this.height,
    this.borderWidth,
    this.fontSize,
    this.bgColor,
    this.txtColor,
    this.borderColor
  });
}
```

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `unreadCount` | `int` | The numerical value to display and format |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `width` | `double?` | `38.w` | Width of the circular badge |
| `height` | `double?` | `38.w` | Height of the circular badge |
| `borderWidth` | `double?` | `1.w` | Thickness of the border |
| `fontSize` | `double?` | `4.sp` | Font size of the displayed number |
| `bgColor` | `Color?` | `AppColors.getRedColor(context)` | Background color |
| `txtColor` | `Color?` | `AppColors.getReversedTextColor(context)` | Text color |
| `borderColor` | `Color?` | `AppColors.getReversedTextColor(context)` | Border color |

## Features

### 🔢 **Automatic Number Formatting**
The widget automatically formats numbers with appropriate suffixes:

| Range | Format | Examples |
|-------|--------|----------|
| 0-999 | Exact number | 1, 42, 999 |
| 1,000-999,999 | K suffix | 1K, 5.5K, 999K |
| 1,000,000-999,999,999 | M suffix | 1M, 2.5M, 999M |
| 1,000,000,000+ | B suffix | 1B, 1.5B, 2B |

### 🎨 **Responsive Design**
- Uses ScreenUtil for consistent sizing across devices
- Automatic font scaling with `AutoSizeText`
- Configurable minimum font size (6sp)

### 🌐 **Localization Support**
- Respects Arabic/English locale settings
- Uses `context.isArabic` for language-specific formatting

### 🎯 **Theme Integration**
- Automatically adapts to light/dark themes
- Uses app-defined color schemes
- Proper contrast for accessibility

## Usage Examples

### Basic Counter
```dart
CounterWidget(
  unreadCount: 5,
)
```

### Notification Badge
```dart
Stack(
  children: [
    IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () => openNotifications(),
    ),
    if (notificationCount > 0)
      Positioned(
        right: 0,
        top: 0,
        child: CounterWidget(
          unreadCount: notificationCount,
          width: 20,
          height: 20,
          fontSize: 10,
        ),
      ),
  ],
)
```

### Message Counter
```dart
ListTile(
  leading: CircleAvatar(
    backgroundImage: NetworkImage(user.avatar),
  ),
  title: Text(user.name),
  subtitle: Text(lastMessage),
  trailing: unreadMessages > 0
      ? CounterWidget(
          unreadCount: unreadMessages,
          bgColor: AppColors.PRIMARY_COLOR,
          txtColor: Colors.white,
        )
      : null,
)
```

### Custom Styled Counter
```dart
CounterWidget(
  unreadCount: 1500000, // Displays as "1.5M"
  width: 60,
  height: 60,
  fontSize: 16,
  bgColor: Colors.green,
  txtColor: Colors.white,
  borderColor: Colors.green[700],
  borderWidth: 2,
)
```

### Social Media Metrics
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    _buildMetric('Followers', followersCount),
    _buildMetric('Following', followingCount),
    _buildMetric('Posts', postsCount),
  ],
)

Widget _buildMetric(String label, int count) {
  return Column(
    children: [
      CounterWidget(
        unreadCount: count,
        width: 50,
        height: 50,
        bgColor: Colors.blue[100],
        txtColor: Colors.blue[800],
        borderColor: Colors.blue[300],
      ),
      SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 12)),
    ],
  );
}
```

## Number Formatting Logic

### Implementation Details
```dart
String formatNumber(num number, {bool isArabic = false}) {
  String suffix = '';
  String result = '';

  if (number >= 1e9) {
    result = (number / 1e9).toStringAsFixed(1).replaceAll(RegExp(r"\.0$"), '');
    suffix = 'B';
  } else if (number >= 1e6) {
    result = (number / 1e6).toStringAsFixed(1).replaceAll(RegExp(r"\.0$"), '');
    suffix = 'M';
  } else if (number >= 1e3) {
    result = (number / 1e3).toStringAsFixed(1).replaceAll(RegExp(r"\.0$"), '');
    suffix = 'K';
  } else {
    result = number.toString();
  }

  return '$result$suffix';
}
```

### Formatting Examples
```dart
// Examples of number formatting
formatNumber(0)          // "0"
formatNumber(42)         // "42"
formatNumber(1000)       // "1K"
formatNumber(1500)       // "1.5K"
formatNumber(1000000)    // "1M"
formatNumber(2500000)    // "2.5M"
formatNumber(1000000000) // "1B"
formatNumber(1500000000) // "1.5B"
```

### Decimal Handling
- Removes trailing zeros (1.0K becomes 1K)
- Shows one decimal place for precision
- Handles edge cases properly

## Styling and Customization

### Size Variations
```dart
// Small badge
CounterWidget(
  unreadCount: count,
  width: 20,
  height: 20,
  fontSize: 8,
)

// Medium badge (default)
CounterWidget(
  unreadCount: count,
  width: 38,
  height: 38,
  fontSize: 12,
)

// Large badge
CounterWidget(
  unreadCount: count,
  width: 60,
  height: 60,
  fontSize: 18,
)
```

### Color Schemes
```dart
// Success theme
CounterWidget(
  unreadCount: count,
  bgColor: Colors.green,
  txtColor: Colors.white,
  borderColor: Colors.green[700],
)

// Warning theme
CounterWidget(
  unreadCount: count,
  bgColor: Colors.orange,
  txtColor: Colors.white,
  borderColor: Colors.orange[700],
)

// Error theme
CounterWidget(
  unreadCount: count,
  bgColor: Colors.red,
  txtColor: Colors.white,
  borderColor: Colors.red[700],
)

// Neutral theme
CounterWidget(
  unreadCount: count,
  bgColor: Colors.grey[200],
  txtColor: Colors.grey[800],
  borderColor: Colors.grey[400],
)
```

### Theme-Aware Implementation
```dart
class ThemedCounterWidget extends StatelessWidget {
  final int count;
  final CounterTheme theme;

  const ThemedCounterWidget({
    required this.count,
    this.theme = CounterTheme.primary,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color txtColor;
    Color borderColor;

    switch (theme) {
      case CounterTheme.primary:
        bgColor = Theme.of(context).primaryColor;
        txtColor = Colors.white;
        borderColor = Theme.of(context).primaryColorDark;
        break;
      case CounterTheme.accent:
        bgColor = Theme.of(context).accentColor;
        txtColor = Colors.white;
        borderColor = Theme.of(context).accentColor;
        break;
      case CounterTheme.success:
        bgColor = Colors.green;
        txtColor = Colors.white;
        borderColor = Colors.green[700]!;
        break;
      // ... other themes
    }

    return CounterWidget(
      unreadCount: count,
      bgColor: bgColor,
      txtColor: txtColor,
      borderColor: borderColor,
    );
  }
}

enum CounterTheme { primary, accent, success, warning, error, neutral }
```

## Advanced Usage Patterns

### Animated Counter
```dart
class AnimatedCounterWidget extends StatefulWidget {
  final int targetCount;
  final Duration duration;

  const AnimatedCounterWidget({
    required this.targetCount,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  _AnimatedCounterWidgetState createState() => _AnimatedCounterWidgetState();
}

class _AnimatedCounterWidgetState extends State<AnimatedCounterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = IntTween(begin: 0, end: widget.targetCount).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetCount != widget.targetCount) {
      _animation = IntTween(
        begin: _animation.value,
        end: widget.targetCount,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CounterWidget(
          unreadCount: _animation.value,
        );
      },
    );
  }
}
```

### Interactive Counter
```dart
class InteractiveCounterWidget extends StatefulWidget {
  final int initialCount;
  final ValueChanged<int>? onCountChanged;

  const InteractiveCounterWidget({
    this.initialCount = 0,
    this.onCountChanged,
  });

  @override
  _InteractiveCounterWidgetState createState() => _InteractiveCounterWidgetState();
}

class _InteractiveCounterWidgetState extends State<InteractiveCounterWidget> {
  late int currentCount;

  @override
  void initState() {
    super.initState();
    currentCount = widget.initialCount;
  }

  void increment() {
    setState(() {
      currentCount++;
    });
    widget.onCountChanged?.call(currentCount);
  }

  void decrement() {
    if (currentCount > 0) {
      setState(() {
        currentCount--;
      });
      widget.onCountChanged?.call(currentCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: currentCount > 0 ? decrement : null,
        ),
        GestureDetector(
          onTap: increment,
          child: CounterWidget(
            unreadCount: currentCount,
          ),
        