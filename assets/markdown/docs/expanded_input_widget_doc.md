# ExpandedInputWidget Documentation

## Overview

`ExpandedInputWidget` is a Flutter widget that creates an expandable dropdown-style input field. When tapped, it reveals a scrollable list of options in a custom-styled dropdown container. This widget is perfect for scenarios where you need a clean, space-efficient way to present multiple selection options.

## Widget Structure

```dart
class ExpandedInputWidget extends StatefulWidget {
  const ExpandedInputWidget({
    super.key,
    required this.title,
    this.disableMsg = '',
    this.enabled = true,
    required this.dropDownList,
    required this.onSelectItem,
    this.clearData,
    this.controller,
    this.subTitle,
    this.price,
    this.secondSubTitle,
    this.hint,
    this.editText,
    this.titleColor,
    this.isEditAds = false,
    this.formatters,
  });
}
```

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | `String` | Main label displayed above the input field |
| `dropDownList` | `List<String>` | List of selectable options |
| `onSelectItem` | `void Function(int)` | Callback function with selected item index |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `controller` | `TextEditingController?` | `null` | Text controller for the input field |
| `enabled` | `bool?` | `true` | Whether the widget is interactive |
| `disableMsg` | `String` | `''` | Message shown when widget is disabled |
| `hint` | `String?` | `null` | Placeholder text for the input field |
| `subTitle` | `String?` | `null` | Additional description text |
| `secondSubTitle` | `String?` | `null` | Secondary description text |
| `price` | `String?` | `null` | Price information (currently commented out) |
| `editText` | `String?` | `null` | Initial text value |
| `titleColor` | `Color?` | `null` | Custom color for the title text |
| `isEditAds` | `bool?` | `false` | Special styling mode for advertisements |
| `formatters` | `List<TextInputFormatter>?` | `null` | Input formatting rules |
| `clearData` | `VoidCallback?` | `null` | Callback to clear data |

## Features

### 🔄 **Expandable Interface**
- Clean collapsed state showing selected value
- Smooth expansion to reveal all options
- Visual feedback with arrow direction changes

### 🎨 **Custom Styling**
- Rounded corners with dynamic border radius
- Golden divider when expanded (`AppColors.PRIMARY_COLOR`)
- Black dropdown container with proper contrast
- Responsive design using ScreenUtil

### 📋 **Scrollable Options**
- Maximum height constraint (250.h) with scroll
- Touch-friendly option selection
- Proper spacing and alignment

### ⚡ **State Management**
- Internal expansion state handling
- Controller management with proper initialization
- Selection feedback and UI updates

### 🚫 **Disabled State Handling**
- Shows error message when disabled
- Visual feedback for non-interactive state
- Prevents accidental interactions

## Usage Examples

### Basic Implementation
```dart
class CategorySelector extends StatefulWidget {
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final List<String> categories = [
    'Electronics',
    'Clothing',
    'Home & Garden',
    'Sports & Outdoors',
    'Books & Media'
  ];
  
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return ExpandedInputWidget(
      title: 'Product Category',
      dropDownList: categories,
      hint: 'Select a category',
      onSelectItem: (index) {
        setState(() {
          selectedCategory = categories[index];
        });
        print('Selected: ${categories[index]} at index $index');
      },
    );
  }
}
```

### With Custom Controller
```dart
class ControlledExpandedInput extends StatefulWidget {
  @override
  _ControlledExpandedInputState createState() => _ControlledExpandedInputState();
}

class _ControlledExpandedInputState extends State<ControlledExpandedInput> {
  final TextEditingController _controller = TextEditingController();
  final List<String> options = ['Option A', 'Option B', 'Option C'];

  @override
  void initState() {
    super.initState();
    _controller.text = 'Pre-selected value';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandedInputWidget(
      title: 'Controlled Selection',
      controller: _controller,
      dropDownList: options,
      hint: 'Choose an option',
      onSelectItem: (index) {
        print('Selected index: $index');
        // Controller text is automatically updated
      },
    );
  }
}
```

### With Subtitle and Descriptions
```dart
ExpandedInputWidget(
  title: 'Service Package',
  subTitle: 'Choose your preferred service level',
  secondSubTitle: 'Different packages offer varying features and support',
  dropDownList: [
    'Basic Package - Essential features',
    'Premium Package - Advanced features + Support',
    'Enterprise Package - Full features + Priority Support'
  ],
  hint: 'Select package',
  titleColor: AppColors.PRIMARY_COLOR,
  onSelectItem: (index) {
    handlePackageSelection(index);
  },
)
```

### Disabled State with Message
```dart
class ConditionalExpandedInput extends StatefulWidget {
  @override
  _ConditionalExpandedInputState createState() => _ConditionalExpandedInputState();
}

class _ConditionalExpandedInputState extends State<ConditionalExpandedInput> {
  bool userHasPermission = false;
  final List<String> restrictedOptions = [
    'Admin Option 1',
    'Admin Option 2',
    'Admin Option 3'
  ];

  @override
  Widget build(BuildContext context) {
    return ExpandedInputWidget(
      title: 'Admin Settings',
      dropDownList: restrictedOptions,
      enabled: userHasPermission,
      disableMsg: 'Administrator privileges required to access these options',
      hint: userHasPermission ? 'Select admin option' : 'Access denied',
      onSelectItem: (index) {
        if (userHasPermission) {
          handleAdminSelection(index);
        }
      },
    );
  }
}
```

### With Input Formatters
```dart
ExpandedInputWidget(
  title: 'Formatted Input',
  dropDownList: phoneFormats,
  hint: 'Select phone format',
  formatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(15),
    // Custom phone number formatter
    PhoneNumberFormatter(),
  ],
  onSelectItem: (index) {
    applyPhoneFormat(phoneFormats[index]);
  },
)
```

### Edit Mode for Advertisements
```dart
ExpandedInputWidget(
  title: 'Advertisement Category',
  isEditAds: true,
  editText: existingAdCategory,
  dropDownList: adCategories,
  subTitle: 'Select the most appropriate category for your ad',
  hint: 'Choose category',
  onSelectItem: (index) {
    updateAdCategory(adCategories[index]);
  },
  clearData: () {
    // Clear existing ad data
    clearAdForm();
  },
)
```

## Visual Behavior

### Collapsed State
```
┌─────────────────────────────────────┐
│ Title                               │
│ ┌─────────────────────────────────┐ │
│ │ Selected Value          ▼       │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

### Expanded State
```
┌─────────────────────────────────────┐
│ Title                               │
│ ┌─────────────────────────────────┐ │
│ │ Selected Value          ▲       │ │
│ ├─────────────────────────────────┤ │ Golden divider
│ │ Option 1                        │ │
│ │ Option 2                        │ │ Black container
│ │ Option 3                        │ │ with scroll
│ │ ...                             │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## Styling Details

### Container Styling
```dart
// Collapsed state
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(6.r),
    color: Colors.white,
  ),
)

// Expanded state (top part)
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(6.r),
      topRight: Radius.circular(6.r),
    ),
    color: Colors.white,
  ),
)

// Expanded state (dropdown part)
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(6.r),
      bottomRight: Radius.circular(6.r),
    ),
    color: Colors.black,
  ),
)
```

### Typography
- **Title**: `15.sp`, `FontWeight.w600`
- **Subtitle**: `11.sp`, `FontWeight.w400`, 33% opacity
- **Options**: Theme-based `headlineMedium` font size, `FontWeight.w500`

### Spacing and Dimensions
- **Option Height**: `40.h`
- **Max Dropdown Height**: `250.h`
- **Horizontal Padding**: `16.w`
- **Border Radius**: `6.r`

## Advanced Features

### Dynamic Option Loading
```dart
class DynamicExpandedInput extends StatefulWidget {
  @override
  _DynamicExpandedInputState createState() => _DynamicExpandedInputState();
}

class _DynamicExpandedInputState extends State<DynamicExpandedInput> {
  List<String> options = ['Loading...'];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOptions();
  }

  Future<void> loadOptions() async {
    try {
      final data = await ApiService.fetchOptions();
      setState(() {
        options = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        options = ['Error loading options'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpandedInputWidget(
      title: 'Dynamic Options',
      dropDownList: options,
      enabled: !isLoading,
      disableMsg: isLoading ? 'Loading options...' : 'Failed to load options',
      hint: isLoading ? 'Loading...' : 'Select option',
      onSelectItem: (index) {
        if (!isLoading && options[index] != 'Error loading options') {
          handleSelection(options[index]);
        }
      },
    );
  }
}
```

### Filtered Options
```dart
class FilteredExpandedInput extends StatefulWidget {
  final List<String> allOptions;
  final String filterCriteria;

  const FilteredExpandedInput({
    required this.allOptions,
    required this.filterCriteria,
  });

  @override
  _FilteredExpandedInputState createState() => _FilteredExpandedInputState();
}

class _FilteredExpandedInputState extends State<FilteredExpandedInput> {
  List<String> filteredOptions = [];

  @override
  void initState() {
    super.initState();
    applyFilter();
  }

  @override
  void didUpdateWidget(FilteredExpandedInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filterCriteria != widget.filterCriteria) {
      applyFilter();
    }
  }

  void applyFilter() {
    setState(() {
      filteredOptions = widget.allOptions
          .where((option) => option
              .toLowerCase()
              .contains(widget.filterCriteria.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpandedInputWidget(
      title: 'Filtered Selection',
      dropDownList: filteredOptions.isNotEmpty 
          ? filteredOptions 
          : ['No matching options'],
      hint: 'Select from filtered results',
      enabled: filteredOptions.isNotEmpty,
      disableMsg: 'No options match the current filter',
      onSelectItem: (index) {
        if (filteredOptions.isNotEmpty && 
            filteredOptions[index] != 'No matching options') {
          final selectedOption = filteredOptions[index];
          final originalIndex = widget.allOptions.indexOf(selectedOption);
          handleFilteredSelection(originalIndex, selectedOption);
        }
      },
    );
  }
}
```

### Multi-Selection Mode
```dart
class MultiSelectExpandedInput extends StatefulWidget {
  @override
  _MultiSelectExpandedInputState createState() => _MultiSelectExpandedInputState();
}

class _MultiSelectExpandedInputState extends State<MultiSelectExpandedInput> {
  final List<String> options = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
  final Set<int> selectedIndices = {};
  final TextEditingController controller = TextEditingController();

  void updateDisplayText() {
    final selectedOptions = selectedIndices
        .map((index) => options[index])
        .join(', ');
    controller.text = selectedOptions.isEmpty ? '' : selectedOptions;
  }

  @override
  Widget build(BuildContext context) {
    return ExpandedInputWidget(
      title: 'Multi-Selection',
      controller: controller,
      dropDownList: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = selectedIndices.contains(index);
        return '${isSelected ? '✓ ' : '  '}$option';
      }).toList(),
      hint: 'Select multiple options',
      onSelectItem: (index) {
        setState(() {
          if (selectedIndices.contains(index)) {
            selectedIndices.remove(index);
          } else {
            selectedIndices.add(index);
          }
          updateDisplayText();
        });
      },
    );
  }
}
```

## Error Handling

### Input Validation
```dart
class ValidatedExpandedInput extends StatefulWidget {
  @override
  _ValidatedExpandedInputState createState() => _ValidatedExpandedInputState();
}

class _ValidatedExpandedInputState extends State<ValidatedExpandedInput> {
  final TextEditingController controller = TextEditingController();
  String? errorMessage;
  final List<String> options = ['Valid Option 1', 'Valid Option 2'];

  bool validateSelection(String value) {
    if (value.isEmpty) {
      setState(() {
        errorMessage = 'Please select an option';
      });
      return false;
    }
    
    if (!options.contains(value)) {
      setState(() {
        errorMessage = 'Invalid selection';
      });
      return false;
    }

    setState(() {
      errorMessage = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpandedInputWidget(
          title: 'Validated Selection',
          controller: controller,
          dropDownList: options,
          hint: 'Choose valid option',
          onSelectItem: (index) {
            validateSelection(options[index]);
          },
        ),
        if (errorMessage != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              errorMessage!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }
}
```

### Network Error Handling
```dart
class NetworkAwareExpandedInput extends StatefulWidget {
  @override
  _NetworkAwareExpandedInputState createState() => _NetworkAwareExpandedInputState();
}

class _NetworkAwareExpandedInputState extends State<NetworkAwareExpandedInput> {
  List<String> options = [];
  String? errorMessage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadNetworkOptions();
  }

  Future<void> loadNetworkOptions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await NetworkService.fetchOptions();
      setState(() {
        options = response.data;
        isLoading = false;
      });
    } on NetworkException catch (e) {
      setState(() {
        errorMessage = 'Network error: ${e.message}';
        options = ['Retry loading options'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Unexpected error occurred';
        options = ['Retry loading options'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpandedInputWidget(
          title: 'Network Options',
          dropDownList: isLoading ? ['Loading...'] : options,
          enabled: !isLoading,
          disableMsg: isLoading 
              ? 'Loading options from server...' 
              : errorMessage ?? '',
          hint: isLoading ? 'Loading...' : 'Select option',
          onSelectItem: (index) {
            if (!isLoading) {
              if (options[index] == 'Retry loading options') {
                loadNetworkOptions();
              } else {
                handleNetworkSelection(options[index]);
              }
            }
          },
        ),
        if (errorMessage != null && !isLoading)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 16),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                ),
                TextButton(
                  onPressed: loadNetworkOptions,
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
```

## Accessibility Features

### Screen Reader Support
```dart
Semantics(
  label: 'Category selection input',
  hint: 'Double tap to expand and view all available categories',
  expanded: isExpanded,
  child: ExpandedInputWidget(
    title: 'Category',
    dropDownList: categories,
    hint: 'Select category',
    onSelectItem: handleSelection,
  ),
)
```

### Keyboard Navigation
```dart
class AccessibleExpandedInput extends StatefulWidget {
  @override
  _AccessibleExpandedInputState createState() => _AccessibleExpandedInputState();
}

class _AccessibleExpandedInputState extends State<AccessibleExpandedInput> {
  final FocusNode _focusNode = FocusNode();
  bool isExpanded = false;
  int selectedIndex = -1;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKey: (node, event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown && isExpanded) {
            setState(() {
              selectedIndex = (selectedIndex + 1) % options.length;
            });
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && isExpanded) {
            setState(() {
              selectedIndex = selectedIndex <= 0 ? options.length - 1 : selectedIndex - 1;
            });
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.enter) {
            if (isExpanded && selectedIndex >= 0) {
              handleSelection(selectedIndex);
              setState(() {
                isExpanded = false;
              });
            } else {
              setState(() {
                isExpanded = !isExpanded;
              });
            }
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.escape && isExpanded) {
            setState(() {
              isExpanded = false;
            });
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: ExpandedInputWidget(
        title: 'Accessible Selection',
        dropDownList: options,
        hint: 'Use arrow keys to navigate, Enter to select',
        onSelectItem: handleSelection,
      ),
    );
  }
}
```

## Performance Optimization

### Large Lists with Virtualization
```dart
class VirtualizedExpandedInput extends StatefulWidget {
  final List<String> largeOptionsList;

  const VirtualizedExpandedInput({required this.largeOptionsList});

  @override
  _VirtualizedExpandedInputState createState() => _VirtualizedExpandedInputState();
}

class _VirtualizedExpandedInputState extends State<VirtualizedExpandedInput> {
  static const int VISIBLE_ITEMS = 10;
  int startIndex = 0;
  String searchQuery = '';

  List<String> get filteredOptions {
    if (searchQuery.isEmpty) return widget.largeOptionsList;
    return widget.largeOptionsList
        .where((option) => option.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  List<String> get visibleOptions {
    final filtered = filteredOptions;
    final endIndex = (startIndex + VISIBLE_ITEMS).clamp(0, filtered.length);
    return filtered.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar for large lists
        TextField(
          decoration: InputDecoration(
            hintText: 'Search options...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
              startIndex = 0; // Reset to beginning when searching
            });
          },
        ),
        SizedBox(height: 8.h),
        
        // Virtualized expanded input
        ExpandedInputWidget(
          title: 'Large List (${filteredOptions.length} items)',
          dropDownList: [
            if (startIndex > 0) '⬆ Show previous items',
            ...visibleOptions,
            if (startIndex + VISIBLE_ITEMS < filteredOptions.length) 
              '⬇ Show more items (${filteredOptions.length - startIndex - VISIBLE_ITEMS} remaining)',
          ],
          hint: searchQuery.isEmpty 
              ? 'Search and select from ${widget.largeOptionsList.length} items'
              : 'Select from ${filteredOptions.length} filtered items',
          onSelectItem: (index) {
            final adjustedList = [
              if (startIndex > 0) '⬆ Show previous items',
              ...visibleOptions,
              if (startIndex + VISIBLE_ITEMS < filteredOptions.length) 
                '⬇ Show more items (${filteredOptions.length - startIndex - VISIBLE_ITEMS} remaining)',
            ];
            
            final selectedOption = adjustedList[index];
            
            if (selectedOption == '⬆ Show previous items') {
              setState(() {
                startIndex = (startIndex - VISIBLE_ITEMS).clamp(0, filteredOptions.length);
              });
            } else if (selectedOption.startsWith('⬇ Show more items')) {
              setState(() {
                startIndex = (startIndex + VISIBLE_ITEMS).clamp(0, filteredOptions.length - VISIBLE_ITEMS);
              });
            } else {
              // Handle actual selection
              final actualIndex = filteredOptions.indexOf(selectedOption);
              if (actualIndex >= 0) {
                handleLargeListSelection(actualIndex, selectedOption);
              }
            }
          },
        ),
      ],
    );
  }
}
```

### Memory Management
```dart
class MemoryEfficientExpandedInput extends StatefulWidget {
  @override
  _MemoryEfficientExpandedInputState createState() => _MemoryEfficientExpandedInputState();
}

class _MemoryEfficientExpandedInputState extends State<MemoryEfficientExpandedInput> {
  late TextEditingController _controller;
  List<String>? _cachedOptions;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    _cachedOptions?.clear();
    super.dispose();
  }

  Future<List<String>> getOptions() async {
    _cachedOptions ??= await ExpensiveDataService.loadOptions();
    return _cachedOptions!;
  }

  void handleSelectionWithDebounce(int index) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 300), () {
      // Process selection after debounce
      processSelection(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getOptions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ExpandedInputWidget(
            title: 'Loading Options',
            dropDownList: ['Loading...'],
            enabled: false,
            disableMsg: 'Loading options, please wait...',
            hint: 'Please wait',
            onSelectItem: (_) {},
          );
        }

        if (snapshot.hasError) {
          return ExpandedInputWidget(
            title: 'Error Loading Options',
            dropDownList: ['Retry'],
            hint: 'Tap to retry',
            onSelectItem: (_) {
              setState(() {
                _cachedOptions = null; // Clear cache to retry
              });
            },
          );
        }

        return ExpandedInputWidget(
          title: 'Efficient Selection',
          controller: _controller,
          dropDownList: snapshot.data!,
          hint: 'Select option',
          onSelectItem: handleSelectionWithDebounce,
        );
      },
    );
  }
}
```

## Testing

### Unit Tests
```dart
testWidgets('ExpandedInputWidget displays title and hint', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ExpandedInputWidget(
          title: 'Test Title',
          dropDownList: ['Option 1', 'Option 2'],
          hint: 'Test Hint',
          onSelectItem: (index) {},
        ),
      ),
    ),
  );

  expect(find.text('Test Title'), findsOneWidget);
  expect(find.text('Test Hint'), findsOneWidget);
});

testWidgets('ExpandedInputWidget expands when tapped', (tester) async {
  bool expanded = false;
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) {
            return ExpandedInputWidget(
              title: 'Expandable Test',
              dropDownList: ['Option 1', 'Option 2'],
              hint: 'Tap to expand',
              onSelectItem: (index) {
                setState(() {
                  expanded = true;
                });
              },
            );
          },
        ),
      ),
    ),
  );

  // Initially collapsed
  expect(find.text('Option 1'), findsNothing);
  
  // Tap to expand
  await tester.tap(find.byType(GestureDetector).first);
  await tester.pumpAndSettle();
  
  // Should show options
  expect(find.text('Option 1'), findsOneWidget);
  expect(find.text('Option 2'), findsOneWidget);
});

testWidgets('ExpandedInputWidget handles disabled state', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ExpandedInputWidget(
          title: 'Disabled Test',
          dropDownList: ['Option 1'],
          enabled: false,
          disableMsg: 'Widget is disabled',
          hint: 'Cannot select',
          onSelectItem: (index) {},
        ),
      ),
    ),
  );

  // Tap should show error message
  await tester.tap(find.byType(GestureDetector).first);
  await tester.pumpAndSettle();
  
  // Should not expand, but show error
  expect(find.text('Option 1'), findsNothing);
});
```

### Integration Tests
```dart
group('ExpandedInputWidget Integration Tests', () {
  testWidgets('Selection updates controller text', (tester) async {
    final controller = TextEditingController();
    final options = ['Apple', 'Banana', 'Orange'];
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpandedInputWidget(
            title: 'Fruit Selection',
            controller: controller,
            dropDownList: options,
            hint: 'Select fruit',
            onSelectItem: (index) {},
          ),
        ),
      ),
    );

    // Expand and select option
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();

    expect(controller.text, equals('Banana'));
  });

  testWidgets('Multiple selections work correctly', (tester) async {
    int lastSelectedIndex = -1;
    final options = ['Item 1', 'Item 2', 'Item 3'];
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return ExpandedInputWidget(
                title: 'Multi Selection Test',
                dropDownList: options,
                hint: 'Select items',
                onSelectItem: (index) {
                  setState(() {
                    lastSelectedIndex = index;
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    // Test multiple selections
    for (int i = 0; i < options.length; i++) {
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      
      await tester.tap(find.text(options[i]));
      await tester.pumpAndSettle();
      
      expect(lastSelectedIndex, equals(i));
    }
  });
});
```

## Common Patterns

### Form Integration
```dart
class FormWithExpandedInput extends StatefulWidget {
  @override
  _FormWithExpandedInputState createState() => _FormWithExpandedInputState();
}

class _FormWithExpandedInputState extends State<FormWithExpandedInput> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  
  final List<String> categories = ['Electronics', 'Clothing', 'Books'];
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Product Name'),
            validator: (value) => value?.isEmpty == true ? 'Required' : null,
          ),
          
          SizedBox(height: 16.h),
          
          ExpandedInputWidget(
            title: 'Category *',
            controller: _categoryController,
            dropDownList: categories,
            hint: 'Select category',
            onSelectItem: (index) {
              // Trigger form validation after selection
              _formKey.currentState?.validate();
            },
          ),
          
          // Custom validation for ExpandedInputWidget
          if (_categoryController.text.isEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  'Category is required',
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              ),
            ),
          
          SizedBox(height: 24.h),
          
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && 
                  _categoryController.text.isNotEmpty) {
                submitForm();
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

## Migration Guide

### From DropdownButtonFormField
```dart
// Before
DropdownButtonFormField<String>(
  decoration: InputDecoration(labelText: 'Category'),
  items: categories.map((category) => 
    DropdownMenuItem(value: category, child: Text(category))
  ).toList(),
  onChanged: (value) => setState(() => selectedCategory = value),
)

// After  
ExpandedInputWidget(
  title: 'Category',
  dropDownList: categories,
  hint: 'Select category',
  onSelectItem: (index) => setState(() => selectedCategory = categories[index]),
)
```

### From Custom Dropdown Implementation
```dart
// Before - Custom implementation with AnimatedContainer
AnimatedContainer(
  duration: Duration(milliseconds: 200),
  height: isExpanded ? 200 : 50,
  child: ListView(children: options.map((option) => 
    ListTile(title: Text(option), onTap: () => select(option))
  ).toList()),
)

// After - Using ExpandedInputWidget
ExpandedInputWidget(
  title: 'Options',
  dropDownList: options,
  hint: 'Select option',
  onSelectItem: (index) => select(options[index]),
)
```

## Dependencies

```yaml
dependencies:
  flutter_screenutil: ^5.8.4
```

## Conclusion

`ExpandedInputWidget` provides a powerful, customizable solution for dropdown-style selections with a clean, expandable interface. Its built-in state management, accessibility features, and flexible styling make it ideal for forms, filters, and any scenario requiring user selection from a list of options. The widget's performance optimizations and error handling capabilities ensure a smooth user experience even with large datasets or network-dependent content.