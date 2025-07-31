# CustomDropDown Documentation

## Overview

`CustomDropDown` is a Flutter widget that provides a customizable dropdown selection component with built-in translation support, consistent styling, and form validation. It extends the standard `DropdownButtonFormField` with enhanced features for multi-language applications.

## Widget Structure

```dart
class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.list,
    this.hasTranslation = false,
    this.onTap,
    required this.hint,
    required this.onSelect,
    this.value,
    this.height,
    this.verticalPadding,
    this.validator,
  });
}
```

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `list` | `List<dynamic>` | List of dropdown options |
| `hint` | `String` | Placeholder text shown when no item is selected |
| `onSelect` | `Function(dynamic)` | Callback function when an item is selected |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `value` | `dynamic` | `null` | Currently selected value |
| `height` | `double?` | `42.h` | Height of the dropdown widget |
| `verticalPadding` | `double?` | `8.h` | Vertical padding inside the dropdown |
| `hasTranslation` | `bool?` | `false` | Whether items support Arabic/English translation |
| `validator` | `FormFieldValidator<dynamic>?` | `null` | Custom validation function |
| `onTap` | `VoidCallback?` | `null` | Additional callback when dropdown is tapped |

## Features

### 🌐 **Translation Support**
Automatically displays content in Arabic or English based on the current locale:

```dart
// For translated items with nameAr and nameEn properties
CustomDropDown(
  hasTranslation: true,
  list: translatedItems,
  // ...
)
```

### 🎨 **Consistent Styling**
- Uniform border styling with `AppColors.GREY_DARK_COLOR`
- Responsive design using ScreenUtil (`42.h`, `8.h`, etc.)
- Custom arrow icon with proper sizing (`14.w`)
- White dropdown background for better contrast

### ✅ **Form Integration**
- Built-in validation support
- Seamless integration with Flutter's form widgets
- Default validation message: "Please select an item"

### 📱 **Responsive Design**
- Uses ScreenUtil for consistent sizing across devices
- Adaptable height and padding parameters
- Proper font sizing (`13.sp`) for different screen densities

## Usage Examples

### Basic Dropdown
```dart
final List<String> options = ['Option 1', 'Option 2', 'Option 3'];
String? selectedValue;

CustomDropDown(
  list: options,
  hint: 'Select an option',
  value: selectedValue,
  onSelect: (value) {
    setState(() {
      selectedValue = value;
    });
  },
)
```

### With Translation Support
```dart
final List<TranslatedItem> translatedOptions = [
  TranslatedItem(nameEn: 'Apple', nameAr: 'تفاحة'),
  TranslatedItem(nameEn: 'Orange', nameAr: 'برتقالة'),
  TranslatedItem(nameEn: 'Banana', nameAr: 'موزة'),
];

CustomDropDown(
  list: translatedOptions,
  hasTranslation: true,
  hint: context.isArabic ? 'اختر خيار' : 'Select option',
  onSelect: (value) => handleSelection(value),
)
```

### In Forms with Validation
```dart
Form(
  key: formKey,
  child: Column(
    children: [
      CustomDropDown(
        list: categories,
        hint: 'Select Category',
        value: selectedCategory,
        onSelect: (category) {
          setState(() {
            selectedCategory = category;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Category is required';
          }
          return null;
        },
      ),
      ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // Process form
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
)
```

### Custom Styling
```dart
CustomDropDown(
  list: items,
  hint: 'Custom styled dropdown',
  height: 50.0,
  verticalPadding: 12.0,
  onSelect: (value) => handleSelection(value),
  onTap: () {
    print('Dropdown tapped');
  },
)
```

### Dynamic Content Loading
```dart
class DynamicDropdown extends StatefulWidget {
  @override
  _DynamicDropdownState createState() => _DynamicDropdownState();
}

class _DynamicDropdownState extends State<DynamicDropdown> {
  List<String> items = [];
  bool isLoading = true;
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      items = ['Loaded Item 1', 'Loaded Item 2', 'Loaded Item 3'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CustomCircularProgressIndicator();
    }

    return CustomDropDown(
      list: items,
      hint: 'Select from loaded items',
      value: selectedValue,
      onSelect: (value) {
        setState(() {
          selectedValue = value;
        });
      },
    );
  }
}
```

## Styling Details

### Border Configuration
```dart
decoration: InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.GREY_DARK_COLOR)
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.GREY_DARK_COLOR)
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.GREY_DARK_COLOR)
  ),
  // ... other border states
)
```

### Typography
- **Font Size**: `13.sp` (responsive)
- **Font Weight**: `FontWeight.w500` (medium)
- **Consistent** across hint, items, and selected value

### Icon Styling
- **Icon**: `Icons.arrow_forward_ios`
- **Size**: `14.w` (responsive)
- **Position**: End of dropdown

## Translation Implementation

### For Simple Strings
```dart
// Without translation
CustomDropDown(
  list: ['English Only', 'Another Option'],
  hasTranslation: false,
  // ...
)
```

### For Translated Objects
```dart
class TranslatedItem {
  final String nameEn;
  final String nameAr;
  
  TranslatedItem({required this.nameEn, required this.nameAr});
}

// Usage
CustomDropDown(
  list: translatedItems,
  hasTranslation: true,
  // Widget automatically shows nameAr or nameEn based on context.isArabic
)
```

### Display Logic
```dart
// Internal implementation
Text(
  hasTranslation == true 
    ? context.isArabic 
      ? item.nameAr 
      : item.nameEn
    : item,
  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
)
```

## Form Validation

### Default Validation
```dart
validator: (value) {
  if (value == null) {
    return 'Please select an item';
  }
  return null;
}
```

### Custom Validation Examples
```dart
// Required field with custom message
validator: (value) {
  if (value == null) {
    return 'Category selection is required';
  }
  return null;
}

// Conditional validation
validator: (value) {
  if (isRequired && value == null) {
    return 'This field cannot be empty';
  }
  if (value != null && !allowedValues.contains(value)) {
    return 'Invalid selection';
  }
  return null;
}

// Complex validation
validator: (value) {
  if (value == null) return 'Selection required';
  
  if (value.toString().length < 3) {
    return 'Selection must be at least 3 characters';
  }
  
  if (dependencies.isNotEmpty && !dependencies.contains(value)) {
    return 'Selection not compatible with previous choices';
  }
  
  return null;
}
```

## Advanced Usage Patterns

### Cascading Dropdowns
```dart
class CascadingDropdowns extends StatefulWidget {
  @override
  _CascadingDropdownsState createState() => _CascadingDropdownsState();
}

class _CascadingDropdownsState extends State<CascadingDropdowns> {
  String? selectedCountry;
  String? selectedCity;
  List<String> cities = [];

  final Map<String, List<String>> countryCities = {
    'Egypt': ['Cairo', 'Alexandria', 'Giza'],
    'Saudi Arabia': ['Riyadh', 'Jeddah', 'Mecca'],
    'UAE': ['Dubai', 'Abu Dhabi', 'Sharjah'],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropDown(
          list: countryCities.keys.toList(),
          hint: 'Select Country',
          value: selectedCountry,
          onSelect: (country) {
            setState(() {
              selectedCountry = country;
              selectedCity = null;
              cities = countryCities[country] ?? [];
            });
          },
        ),
        SizedBox(height: 16),
        CustomDropDown(
          list: cities,
          hint: 'Select City',
          value: selectedCity,
          onSelect: (city) {
            setState(() {
              selectedCity = city;
            });
          },
          validator: (value) {
            if (selectedCountry != null && value == null) {
              return 'Please select a city';
            }
            return null;
          },
        ),
      ],
    );
  }
}
```

### Search-Enabled Dropdown
```dart
class SearchableDropdown extends StatefulWidget {
  final List<String> items;
  
  const SearchableDropdown({required this.items});
  
  @override
  _SearchableDropdownState createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  List<String> filteredItems = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void filterItems(String query) {
    setState(() {
      searchText = query;
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search items...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: filterItems,
        ),
        SizedBox(height: 8),
        CustomDropDown(
          list: filteredItems,
          hint: 'Select from filtered items',
          onSelect: (value) {
            // Handle selection
          },
          onTap: () {
            // Clear search when dropdown is opened
            if (searchText.isNotEmpty) {
              filterItems('');
            }
          },
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
  label: 'Category selection dropdown',
  hint: 'Double tap to open options',
  child: CustomDropDown(
    list: categories,
    hint: 'Select Category',
    onSelect: handleSelection,
  ),
)
```

### Keyboard Navigation
The widget automatically supports:
- **Tab navigation** to focus the dropdown
- **Space/Enter** to open dropdown
- **Arrow keys** to navigate options
- **Escape** to close dropdown

### High Contrast Support
```dart
// The widget adapts to system theme automatically
CustomDropDown(
  list: items,
  hint: 'Accessible dropdown',
  // Colors automatically adjust for high contrast mode
)
```

## Performance Considerations

### Large Lists
```dart
// For large datasets, consider pagination or search
class EfficientDropdown extends StatelessWidget {
  final List<String> allItems;
  final int maxDisplayItems = 100;

  @override
  Widget build(BuildContext context) {
    final displayItems = allItems.length > maxDisplayItems
        ? allItems.take(maxDisplayItems).toList()
        : allItems;

    return CustomDropDown(
      list: displayItems,
      hint: allItems.length > maxDisplayItems
          ? 'Select (showing first $maxDisplayItems items)'
          : 'Select item',
      onSelect: handleSelection,
    );
  }
}
```

### Memory Management
```dart
// Dispose of controllers if using custom implementations
class DropdownContainer extends StatefulWidget {
  @override
  _DropdownContainerState createState() => _DropdownContainerState();
}

class _DropdownContainerState extends State<DropdownContainer> {
  List<String> items = [];

  @override
  void dispose() {
    // Clean up resources
    items.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropDown(
      list: items,
      hint: 'Select option',
      onSelect: (value) {
        // Handle selection efficiently
      },
    );
  }
}
```

## Common Issues & Solutions

### Issue: Items Not Displaying
**Cause**: Empty or null list
**Solution**:
```dart
CustomDropDown(
  list: items.isNotEmpty ? items : ['No items available'],
  hint: 'Select option',
  onSelect: (value) {
    if (value != 'No items available') {
      handleSelection(value);
    }
  },
)
```

### Issue: Translation Not Working
**Cause**: Objects don't have nameAr/nameEn properties
**Solution**:
```dart
// Ensure your objects have the required properties
class TranslatedCategory {
  final String nameEn;
  final String nameAr;
  final String id;
  
  TranslatedCategory({
    required this.nameEn,
    required this.nameAr,
    required this.id,
  });
}
```

### Issue: Validation Not Triggering
**Cause**: Form not properly configured
**Solution**:
```dart
// Wrap in Form widget and call validate
Form(
  key: _formKey,
  child: CustomDropDown(
    // ... parameters
    validator: (value) => value == null ? 'Required' : null,
  ),
)

// Trigger validation
if (_formKey.currentState!.validate()) {
  // Process form
}
```

## Testing

### Unit Tests
```dart
testWidgets('CustomDropDown displays hint text', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CustomDropDown(
          list: ['Item 1', 'Item 2'],
          hint: 'Test Hint',
          onSelect: (value) {},
        ),
      ),
    ),
  );

  expect(find.text('Test Hint'), findsOneWidget);
});

testWidgets('CustomDropDown shows items when tapped', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CustomDropDown(
          list: ['Item 1', 'Item 2'],
          hint: 'Select',
          onSelect: (value) {},
        ),
      ),
    ),
  );

  await tester.tap(find.byType(DropdownButtonFormField));
  await tester.pumpAndSettle();

  expect(find.text('Item 1'), findsOneWidget);
  expect(find.text('Item 2'), findsOneWidget);
});
```

### Integration Tests
```dart
// Test translation functionality
testWidgets('CustomDropDown handles translation correctly', (tester) async {
  final translatedItems = [
    MockTranslatedItem(nameEn: 'English', nameAr: 'عربي'),
  ];

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CustomDropDown(
          list: translatedItems,
          hasTranslation: true,
          hint: 'Select',
          onSelect: (value) {},
        ),
      ),
    ),
  );

  // Test based on current locale
  await tester.tap(find.byType(DropdownButtonFormField));
  await tester.pumpAndSettle();

  // Verify correct language is displayed
  expect(find.text('English'), findsOneWidget);
});
```

## Migration Guide

### From DropdownButtonFormField
```dart
// Before
DropdownButtonFormField<String>(
  hint: Text('Select option'),
  items: items
      .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          ))
      .toList(),
  onChanged: (value) => handleSelection(value),
  validator: (value) => value == null ? 'Required' : null,
)

// After
CustomDropDown(
  list: items,
  hint: 'Select option',
  onSelect: handleSelection,
  validator: (value) => value == null ? 'Required' : null,
)
```

## Dependencies

```yaml
dependencies:
  flutter_screenutil: ^5.8.4
```

## Conclusion

`CustomDropDown` provides a robust, accessible, and internationalized dropdown solution for Flutter applications. Its translation support, consistent styling, and form integration make it ideal for multi-language apps requiring professional UI components.