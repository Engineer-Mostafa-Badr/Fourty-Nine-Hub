# CustomFloatingActionButton Documentation

## Overview

`CustomFloatingActionButton` is a Flutter widget that provides a highly customizable floating action button alternative. Unlike the standard `FloatingActionButton`, this widget offers a pill-shaped design with flexible width, optional text labels, and dynamic theming support. It's perfect for primary actions that need more visual prominence or custom styling that doesn't fit the traditional circular FAB design.

## Widget Structure

```dart
class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.text,
    this.fontSize,
    this.iconSize,
  });

  final void Function() onPressed;
  final IconData? icon;
  final String? text;
  final double? fontSize;
  final double? iconSize;
}
```

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `onPressed` | `void Function()` | Callback function executed when button is pressed |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `icon` | `IconData?` | `null` | Icon to display in the button |
| `text` | `String?` | `null` | Text label to display alongside or instead of icon |
| `fontSize` | `double?` | `16` | Font size for the text label |
| `iconSize` | `double?` | `24` | Size of the icon |

## Key Features

### 🎨 **Dynamic Theming**
- Automatically adapts to app theme using `AppColors`
- Primary button color from theme system
- Reversed text color for optimal contrast
- Consistent with app's design language

### 📏 **Responsive Design**
- Width automatically adjusts to 40% of screen width
- Maintains aspect ratio across different screen sizes
- Flexible content layout with proper spacing

### 🔄 **Flexible Content**
- Icon-only configuration
- Text-only configuration  
- Icon + Text combination
- Customizable icon and text sizes

### 🎭 **Enhanced Visual Design**
- Pill-shaped (rounded rectangle) appearance
- Material elevation shadow (4.0)
- Professional button styling
- Smooth rounded corners (28px radius)

### 📱 **Touch-Friendly**
- Adequate padding for comfortable tapping
- Material button feedback
- Proper touch target size

## Usage Examples

### Icon-Only Button
```dart
class SaveDocumentButton extends StatelessWidget {
  final VoidCallback onSave;

  const SaveDocumentButton({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: onSave,
      icon: Icons.save,
      iconSize: 28,
    );
  }
}

// Usage
Scaffold(
  floatingActionButton: SaveDocumentButton(
    onSave: () => saveCurrentDocument(),
  ),
)
```

### Text-Only Button
```dart
class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;
  final bool isLoading;

  const SubmitButton({
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: isLoading ? () {} : onSubmit,
      text: isLoading ? 'Submitting...' : 'Submit Form',
      fontSize: 18,
    );
  }
}
```

### Icon + Text Combination
```dart
class AddItemButton extends StatelessWidget {
  final VoidCallback onAddItem;

  const AddItemButton({required this.onAddItem});

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: onAddItem,
      icon: Icons.add,
      text: 'Add Item',
      iconSize: 20,
      fontSize: 16,
    );
  }
}

// Usage in shopping cart
Scaffold(
  floatingActionButton: AddItemButton(
    onAddItem: () {
      showModalBottomSheet(
        context: context,
        builder: (context) => AddItemSheet(),
      );
    },
  ),
)
```

### Dynamic Content Based on State
```dart
class StatefulActionButton extends StatefulWidget {
  final Future<void> Function() onAction;

  const StatefulActionButton({required this.onAction});

  @override
  _StatefulActionButtonState createState() => _StatefulActionButtonState();
}

class _StatefulActionButtonState extends State<StatefulActionButton> {
  bool _isLoading = false;
  bool _isCompleted = false;

  Future<void> _handleAction() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _isCompleted = false;
    });

    try {
      await widget.onAction();
      setState(() {
        _isCompleted = true;
      });

      // Reset after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isCompleted = false;
          });
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action failed: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData? icon;
    String? text;

    if (_isLoading) {
      icon = Icons.hourglass_empty;
      text = 'Processing...';
    } else if (_isCompleted) {
      icon = Icons.check_circle;
      text = 'Completed!';
    } else {
      icon = Icons.play_arrow;
      text = 'Start Process';
    }

    return CustomFloatingActionButton(
      onPressed: _handleAction,
      icon: icon,
      text: text,
      iconSize: 22,
      fontSize: 14,
    );
  }
}
```

### E-commerce Cart Button
```dart
class CartActionButton extends StatelessWidget {
  final int itemCount;
  final VoidCallback onViewCart;

  const CartActionButton({
    required this.itemCount,
    required this.onViewCart,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomFloatingActionButton(
          onPressed: onViewCart,
          icon: Icons.shopping_cart,
          text: 'View Cart',
          iconSize: 20,
          fontSize: 14,
        ),
        if (itemCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                '$itemCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

// Usage
CartActionButton(
  itemCount: cartItems.length,
  onViewCart: () => Navigator.pushNamed(context, '/cart'),
)
```

### Multi-Action FAB
```dart
class MultiActionFAB extends StatefulWidget {
  final List<ActionItem> actions;

  const MultiActionFAB({required this.actions});

  @override
  _MultiActionFABState createState() => _MultiActionFABState();
}

class _MultiActionFABState extends State<MultiActionFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _expandAnimation.value,
              child: Opacity(
                opacity: _expandAnimation.value,
                child: Column(
                  children: widget.actions.map((action) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: CustomFloatingActionButton(
                        onPressed: () {
                          _toggleExpanded();
                          action.onPressed();
                        },
                        icon: action.icon,
                        text: action.text,
                        iconSize: 18,
                        fontSize: 12,
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 12),
        CustomFloatingActionButton(
          onPressed: _toggleExpanded,
          icon: _isExpanded ? Icons.close : Icons.add,
          text: _isExpanded ? 'Close' : 'Actions',
          iconSize: 24,
          fontSize: 14,
        ),
      ],
    );
  }
}

class ActionItem {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const ActionItem({
    required this.icon,
    required this.text,
    required this.onPressed,
  });
}

// Usage
MultiActionFAB(
  actions: [
    ActionItem(
      icon: Icons.photo_camera,
      text: 'Camera',
      onPressed: () => openCamera(),
    ),
    ActionItem(
      icon: Icons.photo_library,
      text: 'Gallery',
      onPressed: () => openGallery(),
    ),
    ActionItem(
      icon: Icons.file_upload,
      text: 'Upload',
      onPressed: () => uploadFile(),
    ),
  ],
)
```

## Real-World Examples

### Social Media App
```dart
class PostCreationFAB extends StatelessWidget {
  final VoidCallback onCreatePost;

  const PostCreationFAB({required this.onCreatePost});

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: onCreatePost,
      icon: Icons.edit,
      text: 'Create Post',
      iconSize: 20,
      fontSize: 14,
    );
  }
}

// Usage in social media feed
class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feed')),
      body: FeedList(),
      floatingActionButton: PostCreationFAB(
        onCreatePost: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostPage()),
          );
        },
      ),
    );
  }
}
```

### Task Management App
```dart
class QuickAddTaskFAB extends StatelessWidget {
  final Function(String) onAddTask;

  const QuickAddTaskFAB({required this.onAddTask});

  void _showQuickAddDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quick Add Task'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter task description...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onAddTask(controller.text);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: () => _showQuickAddDialog(context),
      icon: Icons.add_task,
      text: 'Quick Add',
      iconSize: 22,
      fontSize: 13,
    );
  }
}
```

### Music Player App
```dart
class PlayControlFAB extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;

  const PlayControlFAB({
    required this.isPlaying,
    required this.onPlayPause,
  });

  @override
  _PlayControlFABState createState() => _PlayControlFABState();
}

class _PlayControlFABState extends State<PlayControlFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    if (widget.isPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(PlayControlFAB oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: widget.isPlaying ? _rotationController.value * 2 * 3.14159 : 0,
          child: CustomFloatingActionButton(
            onPressed: widget.onPlayPause,
            icon: widget.isPlaying ? Icons.pause : Icons.play_arrow,
            text: widget.isPlaying ? 'Pause' : 'Play',
            iconSize: 28,
            fontSize: 14,
          ),
        );
      },
    );
  }
}
```

### Photo Gallery App
```dart
class GalleryActionsFAB extends StatelessWidget {
  final bool hasSelectedPhotos;
  final int selectedCount;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final VoidCallback onSelectAll;

  const GalleryActionsFAB({
    required this.hasSelectedPhotos,
    required this.selectedCount,
    required this.onShare,
    required this.onDelete,
    required this.onSelectAll,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasSelectedPhotos) {
      return CustomFloatingActionButton(
        onPressed: onSelectAll,
        icon: Icons.select_all,
        text: 'Select All',
        iconSize: 20,
        fontSize: 12,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Share button
        CustomFloatingActionButton(
          onPressed: onShare,
          icon: Icons.share,
          text: 'Share ($selectedCount)',
          iconSize: 18,
          fontSize: 11,
        ),
        SizedBox(height: 12),
        
        // Delete button
        CustomFloatingActionButton(
          onPressed: onDelete,
          icon: Icons.delete,
          text: 'Delete ($selectedCount)',
          iconSize: 18,
          fontSize: 11,
        ),
      ],
    );
  }
}
```

## Advanced Customization

### Theme-Aware Custom Colors
```dart
class ThemedCustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final String? text;
  final CustomFABStyle? style;

  const ThemedCustomFAB({
    required this.onPressed,
    this.icon,
    this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    Color backgroundColor;
    Color textColor;
    
    if (style != null) {
      backgroundColor = style!.backgroundColor ?? 
          AppColors.getButtonPrimaryColor(context);
      textColor = style!.textColor ?? 
          AppColors.getReversedTextColor(context);
    } else {
      backgroundColor = AppColors.getButtonPrimaryColor(context);
      textColor = AppColors.getReversedTextColor(context);
    }

    return SizedBox(
      width: MediaQuery.sizeOf(context).width * (style?.widthFactor ?? 0.4),
      child: RawMaterialButton(
        onPressed: onPressed,
        fillColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style?.borderRadius ?? 28),
        ),
        elevation: style?.elevation ?? 4.0,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: style?.horizontalPadding ?? 16.0,
            vertical: style?.verticalPadding ?? 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) 
                Icon(
                  icon, 
                  color: textColor, 
                  size: style?.iconSize ?? 24,
                ),
              if (icon != null && text != null) 
                SizedBox(width: style?.spacing ?? 8),
              if (text != null)
                Flexible(
                  child: Text(
                    text!,
                    style: TextStyle(
                      color: textColor,
                      fontSize: style?.fontSize ?? 16,
                      fontWeight: style?.fontWeight ?? FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFABStyle {
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final double? iconSize;
  final double? elevation;
  final double? borderRadius;
  final double? widthFactor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? spacing;
  final FontWeight? fontWeight;

  const CustomFABStyle({
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.iconSize,
    this.elevation,
    this.borderRadius,
    this.widthFactor,
    this.horizontalPadding,
    this.verticalPadding,
    this.spacing,
    this.fontWeight,
  });
}
```

### Animated Button States
```dart
class AnimatedCustomFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final String? text;
  final Duration animationDuration;

  const AnimatedCustomFAB({
    required this.onPressed,
    this.icon,
    this.text,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  _AnimatedCustomFABState createState() => _AnimatedCustomFABState();
}

class _AnimatedCustomFABState extends State<AnimatedCustomFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(_) {
    setState(() => _isPressed = false);
    _animationController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: CustomFloatingActionButton(
                onPressed: () {}, // Handled by gesture detector
                icon: widget.icon,
                text: widget.text,
              ),
            ),
          );
        },
      ),
    );
  }
}
```

## Performance Considerations

### Efficient State Management
```dart
class OptimizedCustomFAB extends StatefulWidget {
  final Future<void> Function() onPressed;
  final IconData? icon;
  final String? text;

  const OptimizedCustomFAB({
    required this.onPressed,
    this.icon,
    this.text,
  });

  @override
  _OptimizedCustomFABState createState() => _OptimizedCustomFABState();
}

class _OptimizedCustomFABState extends State<OptimizedCustomFAB> {
  bool _isProcessing = false;

  Future<void> _handlePress() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      await widget.onPressed();
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: _isProcessing ? () {} : _handlePress,
      icon: _isProcessing ? Icons.hourglass_empty : widget.icon,
      text: _isProcessing ? 'Processing...' : widget.text,
      iconSize: 20,
      fontSize: 14,
    );
  }
}
```

### Memory-Efficient Lists
```dart
class ListWithCustomFAB extends StatelessWidget {
  final List<Item> items;
  final Function(Item) onAddSimilar;

  const ListWithCustomFAB({
    required this.items,
    required this.onAddSimilar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.description),
          );
        },
      ),
      floatingActionButton: items.isNotEmpty
          ? CustomFloatingActionButton(
              onPressed: () => onAddSimilar(items.last),
              icon: Icons.add_circle_outline,
              text: 'Add Similar',
              iconSize: 18,
              fontSize: 12,
            )
          : null,
    );
  }
}
```

## Testing

### Widget Tests
```dart
void main() {
  group('CustomFloatingActionButton', () {
    testWidgets('renders with icon and text', (tester) async {
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: CustomFloatingActionButton(
              onPressed: () => wasPressed = true,
              icon: Icons.add,
              text: 'Add Item',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Add Item'), findsOneWidget);
      
      await tester.tap(find.byType(CustomFloatingActionButton));
      expect(wasPressed, isTrue);
    });

    testWidgets('renders with icon only', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: CustomFloatingActionButton(
              onPressed: () {},
              icon: Icons.save,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.text('Add Item'), findsNothing);
    });

    testWidgets('renders with text only', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: CustomFloatingActionButton(
              onPressed: () {},
              text: 'Submit',
            ),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('uses custom font and icon sizes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: CustomFloatingActionButton(
              onPressed: () {},
              icon: Icons.star,
              text: 'Rate',
              fontSize: 20,
              iconSize: 30,
            ),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(iconWidget.size, equals(30));

      final textWidget = tester.widget<Text>(find.text('Rate'));
      expect(textWidget.style?.fontSize, equals(20));
    });

    testWidgets('has proper width constraints', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: CustomFloatingActionButton(
              onPressed: () {},
              text: 'Test Button',
            ),
          ),
        ),
      );

      final sizedBoxWidget = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(RawMaterialButton),
          matching: find.byType(SizedBox),
        ),
      );

      final screenWidth = tester.getSize(find.byType(Scaffold)).width;
      expect(sizedBoxWidget.width, equals(screenWidth * 0.4));
    });
  });
}
```

### Integration Tests
```dart
void main() {
  group('CustomFloatingActionButton Integration', () {
    testWidgets('works with navigation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: CustomFloatingActionButton(
              onPressed: () => Navigator.of(context).pushNamed('/second'),
              icon: Icons.arrow_forward,
              text: 'Next',
            ),
          ),
          routes: {
            '/second': (context) => Scaffold(
              appBar: AppBar(title: Text('Second Page')),
            ),
          },
        ),
      );

      await tester.tap(find.byType(CustomFloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Second Page'), findsOneWidget);
    });

    testWidgets('works with state management', (tester) async {
      int counter = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Center(
                  child: Text('Count: $counter'),
                ),
                floatingActionButton: CustomFloatingActionButton(
                  onPressed: () => setState(() => counter++),
                  icon: Icons.add,
                  text: 'Increment',
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);
      
      await tester.tap(find.byType(CustomFloatingActionButton));
      await tester.pump();
      
      expect(find.text('Count: 1'), findsOneWidget);
    });
  });
}
```

## Comparison with Standard FloatingActionButton

### Standard FAB
```dart
FloatingActionButton(
  onPressed: () => doAction(),
  child: Icon(Icons.add),
)
```

### CustomFloatingActionButton
```dart
CustomFloatingActionButton(
  onPressed: () => doAction(),
  icon: Icons.add,
  text: 'Add Item',
)
```

### Key Differences

| Feature | Standard FAB | CustomFloatingActionButton |
|---------|--------------|----------------------------|
| **Shape** | Circular | Pill-shaped (rounded rectangle) |
| **Size** | Fixed (56x56) | Responsive (40% screen width) |
| **Content** | Single child only | Icon + Text combination |
| **Theming** | Material theme | Custom app colors |
| **Flexibility** | Limited customization | Highly customizable |
| **Text Support** | No native text support | Built-in text support |

## Best Practices

### ✅ Do's
- Use for primary actions that need more visual weight
- Combine icon and text for better user understanding
- Ensure adequate contrast with background
- Use consistent sizing across your app
- Test on different screen sizes

### ❌ Don'ts
- Don't use for secondary actions
- Avoid very long text that might get truncated
- Don't override theme colors without good reason
- Avoid placing multiple CustomFABs on same screen
- Don't use when standard FAB would suffice

### Accessibility Guidelines
```dart
Semantics(
  label: 'Add new item to shopping cart',
  hint: 'Double tap to add item',
  button: true,
  child: CustomFloatingActionButton(
    onPressed: addToCart,
    icon: Icons.add_shopping_cart,
    text: 'Add to Cart',
  ),
)
```

### Performance Tips
```dart
// ✅ Good - Create callback once
class EfficientFAB extends StatelessWidget {
  final VoidCallback onAction;

  const EfficientFAB({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: onAction, // Reuse existing callback
      icon: Icons.check,
      text: 'Complete',
    );
  }
}

// ❌ Avoid - Creating new callback on every build
class InefficientFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: () => print('pressed'), // New function every build
      icon: Icons.check,
      text: 'Complete',
    );
  }
}
```

## Error Handling and Edge Cases

### Null Safety and Validation
```dart
class SafeCustomFAB extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? text;
  final String? fallbackText;

  const SafeCustomFAB({
    this.onPressed,
    this.icon,
    this.text,
    this.fallbackText = 'Action',
  });

  @override
  Widget build(BuildContext context) {
    // Ensure at least one content element exists
    final hasContent = icon != null || 
                      (text?.isNotEmpty ?? false) || 
                      (fallbackText?.isNotEmpty ?? false);
    
    if (!hasContent || onPressed == null) {
      return SizedBox.shrink(); // Return empty widget if invalid
    }

    return CustomFloatingActionButton(
      onPressed: onPressed!,
      icon: icon,
      text: text?.isNotEmpty == true ? text : fallbackText,
      fontSize: 14,
      iconSize: 20,
    );
  }
}
```

### Network Error Handling
```dart
class NetworkActionFAB extends StatefulWidget {
  final Future<void> Function() networkAction;
  final IconData icon;
  final String text;

  const NetworkActionFAB({
    required this.networkAction,
    required this.icon,
    required this.text,
  });

  @override
  _NetworkActionFABState createState() => _NetworkActionFABState();
}

class _NetworkActionFABState extends State<NetworkActionFAB> {
  bool _isLoading = false;
  String? _error;

  Future<void> _handleAction() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await widget.networkAction();
      
      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Action completed successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      setState(() {
        _error = error.toString();
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Action failed: $error')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _handleAction,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData displayIcon;
    String displayText;
    
    if (_isLoading) {
      displayIcon = Icons.hourglass_empty;
      displayText = 'Processing...';
    } else if (_error != null) {
      displayIcon = Icons.refresh;
      displayText = 'Retry';
    } else {
      displayIcon = widget.icon;
      displayText = widget.text;
    }

    return CustomFloatingActionButton(
      onPressed: _isLoading ? null : _handleAction,
      icon: displayIcon,
      text: displayText,
      iconSize: 20,
      fontSize: 13,
    );
  }
}
```

### Form Validation Integration
```dart
class FormSubmitFAB extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Future<void> Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic> formData;

  const FormSubmitFAB({
    required this.formKey,
    required this.onSubmit,
    required this.formData,
  });

  Future<void> _handleSubmit() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      await onSubmit(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _getFormValidationStream(),
      builder: (context, snapshot) {
        final isValid = snapshot.data ?? false;
        
        return CustomFloatingActionButton(
          onPressed: isValid ? _handleSubmit : null,
          icon: isValid ? Icons.check : Icons.warning,
          text: isValid ? 'Submit Form' : 'Complete Required Fields',
          iconSize: 18,
          fontSize: 12,
        );
      },
    );
  }

  Stream<bool> _getFormValidationStream() {
    // Implementation depends on your validation approach
    // This is a simplified example
    return Stream.periodic(
      Duration(milliseconds: 500),
      (_) => formKey.currentState?.validate() ?? false,
    ).distinct();
  }
}
```

## Platform-Specific Adaptations

### iOS-Style Adaptation
```dart
class AdaptiveCustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final String? text;

  const AdaptiveCustomFAB({
    required this.onPressed,
    this.icon,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    
    if (platform == TargetPlatform.iOS) {
      return CupertinoButton.filled(
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(28),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 20),
            if (icon != null && text != null) SizedBox(width: 8),
            if (text != null) Text(text!, style: TextStyle(fontSize: 14)),
          ],
        ),
      );
    }
    
    return CustomFloatingActionButton(
      onPressed: onPressed,
      icon: icon,
      text: text,
    );
  }
}
```

### Web-Specific Optimizations
```dart
class WebOptimizedCustomFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final String? text;

  const WebOptimizedCustomFAB({
    required this.onPressed,
    this.icon,
    this.text,
  });

  @override
  _WebOptimizedCustomFABState createState() => _WebOptimizedCustomFABState();
}

class _WebOptimizedCustomFABState extends State<WebOptimizedCustomFAB> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.05 : 1.0),
        child: CustomFloatingActionButton(
          onPressed: widget.onPressed,
          icon: widget.icon,
          text: widget.text,
        ),
      ),
    );
  }
}
```

## Internationalization (i18n) Support

### Localized Text Support
```dart
class LocalizedCustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final String textKey; // Localization key
  final List<String>? textArgs; // Arguments for parameterized text

  const LocalizedCustomFAB({
    required this.onPressed,
    required this.textKey,
    this.icon,
    this.textArgs,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = Localizations.of(context);
    String localizedText;
    
    try {
      // Assuming you have a localization method
      localizedText = AppLocalizations.of(context).translate(
        textKey, 
        args: textArgs,
      );
    } catch (e) {
      localizedText = textKey; // Fallback to key
    }

    return CustomFloatingActionButton(
      onPressed: onPressed,
      icon: icon,
      text: localizedText,
      fontSize: _getLocalizedFontSize(context),
    );
  }

  double _getLocalizedFontSize(BuildContext context) {
    final locale = Localizations.localeOf(context);
    
    // Adjust font size for different languages
    switch (locale.languageCode) {
      case 'ar': // Arabic
      case 'ur': // Urdu
        return 14; // Slightly smaller for RTL languages
      case 'zh': // Chinese
      case 'ja': // Japanese
        return 15; // Adjust for CJK characters
      default:
        return 16;
    }
  }
}
```

### RTL (Right-to-Left) Support
```dart
class RTLAwareCustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final String? text;

  const RTLAwareCustomFAB({
    required this.onPressed,
    this.icon,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.4,
      child: RawMaterialButton(
        onPressed: onPressed,
        fillColor: AppColors.getButtonPrimaryColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              if (icon != null) 
                Icon(
                  icon, 
                  color: AppColors.getReversedTextColor(context), 
                  size: 24,
                ),
              if (icon != null && text != null) 
                SizedBox(width: 8),
              if (text != null)
                Text(
                  text!,
                  style: TextStyle(
                    color: AppColors.getReversedTextColor(context),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Analytics and Tracking Integration

### Analytics-Enabled FAB
```dart
class AnalyticsCustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final String? text;
  final String eventName;
  final Map<String, dynamic>? eventParameters;

  const AnalyticsCustomFAB({
    required this.onPressed,
    required this.eventName,
    this.icon,
    this.text,
    this.eventParameters,
  });

  Future<void> _handlePressWithAnalytics() async {
    // Track the event
    try {
      await AnalyticsService.trackEvent(
        eventName,
        parameters: {
          'button_text': text ?? 'no_text',
          'button_icon': icon?.codePoint.toString() ?? 'no_icon',
          'timestamp': DateTime.now().toIso8601String(),
          ...?eventParameters,
        },
      );
    } catch (e) {
      debugPrint('Analytics tracking failed: $e');
    }

    // Execute the original callback
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: _handlePressWithAnalytics,
      icon: icon,
      text: text,
    );
  }
}

// Usage
AnalyticsCustomFAB(
  onPressed: () => addItemToCart(product),
  icon: Icons.add_shopping_cart,
  text: 'Add to Cart',
  eventName: 'add_to_cart_button_pressed',
  eventParameters: {
    'product_id': product.id,
    'category': product.category,
    'price': product.price,
  },
)
```

## Migration Guide

### From Standard FloatingActionButton
```dart
// Before - Standard FAB
FloatingActionButton(
  onPressed: () => performAction(),
  child: Icon(Icons.add),
  backgroundColor: Colors.blue,
  heroTag: "addButton",
)

// After - CustomFloatingActionButton
CustomFloatingActionButton(
  onPressed: () => performAction(),
  icon: Icons.add,
  text: 'Add Item', // Now you can add text!
  // Colors automatically handled by theme
)
```

### From Custom Button Implementation
```dart
// Before - Custom implementation
Container(
  width: 200,
  height: 56,
  child: RaisedButton(
    onPressed: () => doAction(),
    color: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.save, color: Colors.white),
        SizedBox(width: 8),
        Text('Save', style: TextStyle(color: Colors.white)),
      ],
    ),
  ),
)

// After - Using CustomFloatingActionButton
CustomFloatingActionButton(
  onPressed: () => doAction(),
  icon: Icons.save,
  text: 'Save',
  // Automatic theming, responsive width, consistent styling
)
```

## Troubleshooting

### Common Issues and Solutions

#### Issue: Button appears too wide/narrow
```dart
// Solution: Adjust width factor
SizedBox(
  width: MediaQuery.sizeOf(context).width * 0.3, // Adjust multiplier
  child: CustomFloatingActionButton(
    onPressed: () => action(),
    text: 'Short text',
  ),
)
```

#### Issue: Text gets truncated
```dart
// Solution: Use shorter text or adjust font size
CustomFloatingActionButton(
  onPressed: () => action(),
  text: 'Add', // Shorter text
  fontSize: 14, // Smaller font
)

// Or implement text overflow handling
Text(
  text ?? '',
  style: TextStyle(
    color: AppColors.getReversedTextColor(context),
    fontSize: fontSize ?? 16,
    fontWeight: FontWeight.bold,
  ),
  overflow: TextOverflow.ellipsis,
  maxLines: 1,
)
```

#### Issue: Colors don't match app theme
```dart
// Ensure AppColors methods are properly implemented
class AppColors {
  static Color getButtonPrimaryColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.primary;
  }

  static Color getReversedTextColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.onPrimary;
  }
}
```

#### Issue: Button not responding to taps
```dart
// Check if onPressed is not null and verify callback
CustomFloatingActionButton(
  onPressed: isEnabled ? () => doAction() : null, // Ensure not null when enabled
  icon: Icons.action,
  text: 'Action',
)
```

## Dependencies

The `CustomFloatingActionButton` requires the following:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
# Custom dependencies (if any)
# your_app_colors_package: ^1.0.0
```

### AppColors Integration
Ensure your app has proper color management:

```dart
// Example AppColors implementation
class AppColors {
  // Light theme colors
  static const Color primaryLight = Color(0xFF2196F3);
  static const Color onPrimaryLight = Colors.white;
  
  // Dark theme colors  
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color onPrimaryDark = Colors.white;

  static Color getButtonPrimaryColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? primaryDark : primaryLight;
  }

  static Color getReversedTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? onPrimaryDark : onPrimaryLight;
  }
}
```

## Conclusion

`CustomFloatingActionButton` provides a modern, flexible alternative to Flutter's standard `FloatingActionButton` with several key advantages:

### 🎯 **Core Benefits**
1. **Flexible Content**: Support for icon, text, or both
2. **Responsive Design**: Automatically adapts to screen sizes
3. **Theme Integration**: Seamlessly works with app themes
4. **Enhanced UX**: Pill-shaped design with better visual hierarchy
5. **Customizable**: Font sizes, icon sizes, and content flexibility

### 🚀 **When to Use**
- Primary actions that need text labels for clarity
- Modern app designs requiring pill-shaped buttons
- Responsive layouts that need adaptive button sizes
- Apps with strong branding requiring custom button styles
- When you need more content flexibility than standard FAB

### ⚠️ **When NOT to Use**
- When Material Design standards are strictly required
- For secondary actions (use regular buttons instead)
- In apps where circular FAB is expected by users
- When standard FAB functionality is sufficient

### 📱 **Perfect For**
- E-commerce apps (Add to Cart, Checkout)
- Social media apps (Create Post, Share)
- Productivity apps (Save, Submit, Create)
- Media apps (Play, Upload, Share)
- Task management apps (Add Task, Complete)

The widget successfully bridges the gap between standard Flutter buttons and custom implementations, providing a professional, accessible, and highly customizable solution for primary action buttons in modern Flutter applications.