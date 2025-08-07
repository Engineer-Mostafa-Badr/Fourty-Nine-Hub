# TextInputWidget Documentation

## Overview

`TextInputWidget` is a highly customizable and reusable text input component built on top of Flutter's `TextFormField`. It provides consistent styling, validation, and formatting capabilities across the application.

## Features

- **Consistent Design**: Unified styling across all text inputs
- **Built-in Validation**: Multiple validation types including email, phone, password, etc.
- **Input Formatting**: Automatic formatting for phone numbers, card numbers, and expiry dates
- **Customizable Appearance**: Flexible styling options for borders, colors, and typography
- **RTL Support**: Right-to-left language support
- **Accessibility**: Screen reader friendly with proper semantic markup

## Basic Usage

```dart
TextInputWidget(
  controller: myController,
  hint: 'Enter your text',
  label: 'Text Field',
  validator: (value) => validation(
    context,
    type: TextFieldValidatorType.normalText,
    value: value ?? '',
  ),
)
```

## Properties

### Required Properties

| Property | Type | Description |
|----------|------|-------------|
| `controller` | `TextEditingController` | Controls the text being edited |
| `validator` | `String? Function(String?)?` | Validation function for the input |

### Optional Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `hint` | `String?` | `null` | Placeholder text shown when field is empty |
| `label` | `String?` | `null` | Label text displayed above the field |
| `textInputType` | `TextInputType?` | `TextInputType.text` | Keyboard type to display |
| `maxLines` | `int?` | `1` | Maximum number of lines for input |
| `maxLength` | `int?` | `null` | Maximum character length |
| `readOnly` | `bool` | `false` | Whether the field is read-only |
| `isPassword` | `bool` | `false` | Whether to obscure text for passwords |
| `enabled` | `bool?` | `true` | Whether the field is enabled |
| `formatters` | `List<TextInputFormatter>?` | `null` | Input formatters for text processing |

### Styling Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `borderRadius` | `double?` | `6.0` | Border radius for the input field |
| `borderColor` | `Color?` | `AppColors.GREY_DARK_COLOR` | Border color |
| `hintColor` | `Color?` | `bodyLarge.color.withOpacity(0.44)` | Hint text color |
| `hintFontSize` | `double?` | `null` | Font size for hint text |
| `labelFontSize` | `double?` | `13.0` | Font size for label text |
| `contentPadding` | `EdgeInsetsGeometry?` | `null` | Internal padding |

### Icon Properties

| Property | Type | Description |
|----------|------|-------------|
| `prefixIcon` | `String?` | SVG asset path for prefix icon |
| `suffixSvg` | `String?` | SVG asset path for suffix icon |
| `prefixWidget` | `Widget?` | Custom prefix widget |
| `suffixWidget` | `Widget?` | Custom suffix widget |

### Event Handlers

| Property | Type | Description |
|----------|------|-------------|
| `onChanged` | `void Function(String)?` | Called when text changes |
| `onSubmitted` | `void Function(String)?` | Called when user submits |
| `onFieldTapped` | `void Function()?` | Called when field is tapped |
| `prefixOnTap` | `void Function()?` | Called when prefix is tapped |
| `onTapOutside` | `void Function(PointerDownEvent)?` | Called when tapped outside |

## Validation Types

The widget supports multiple validation types through `TextFieldValidatorType`:

- `email` - Email address validation
- `password` - Password strength validation (6-25 characters)
- `confirmPassword` - Password confirmation matching
- `phoneNumber` - Phone number format validation (11 digits)
- `emailOrPhoneNumber` - Accepts either email or phone
- `name` - Name validation (no special characters)
- `cardNumber` - Credit card number validation (16 digits)
- `cvc` - CVC code validation (3 digits)
- `normalText` - Required text field
- `optional` - Optional field (no validation)
- `number` - Numeric input validation
- `code` - Verification code validation

## Input Formatters

### MobilePhoneInputFormat
Formats phone numbers with dashes (XXX-XXX-XXXX):

```dart
formatters: [MobilePhoneInputFormat()]
```

### CardInputFormat
Formats credit card numbers with dashes (XXXX-XXXX-XXXX-XXXX):

```dart
formatters: [CardInputFormat()]
```

### CardExpireInputFormat
Formats expiry dates (MM/YY):

```dart
formatters: [CardExpireInputFormat()]
```

## Examples

### Email Input
```dart
TextInputWidget(
  controller: emailController,
  hint: 'Enter your email',
  label: 'Email Address',
  textInputType: TextInputType.emailAddress,
  prefixIcon: 'assets/icons/email_icon.svg',
  validator: (value) => validation(
    context,
    type: TextFieldValidatorType.email,
    value: value ?? '',
  ),
)
```

### Phone Number Input
```dart
TextInputWidget(
  controller: phoneController,
  hint: 'Enter phone number',
  label: 'Phone Number',
  textInputType: TextInputType.phone,
  formatters: [MobilePhoneInputFormat()],
  validator: (value) => validation(
    context,
    type: TextFieldValidatorType.phoneNumber,
    value: value ?? '',
  ),
)
```

### Password Input
```dart
TextInputWidget(
  controller: passwordController,
  hint: 'Enter your password',
  label: 'Password',
  isPassword: true,
  prefixIcon: 'assets/icons/lock_icon.svg',
  validator: (value) => validation(
    context,
    type: TextFieldValidatorType.password,
    value: value ?? '',
  ),
)
```

### Credit Card Input
```dart
TextInputWidget(
  controller: cardController,
  hint: 'Enter card number',
  label: 'Card Number',
  textInputType: TextInputType.number,
  formatters: [
    FilteringTextInputFormatter.digitsOnly,
    CardInputFormat(),
    LengthLimitingTextInputFormatter(19),
  ],
  validator: (value) => validation(
    context,
    type: TextFieldValidatorType.cardNumber,
    value: value?.replaceAll('-', '') ?? '',
  ),
)
```

### Multi-line Text Input
```dart
TextInputWidget(
  controller: messageController,
  hint: 'Enter your message',
  label: 'Message',
  maxLines: 5,
  textInputType: TextInputType.multiline,
  validator: (value) => validation(
    context,
    type: TextFieldValidatorType.normalText,
    value: value ?? '',
  ),
)
```

### Custom Styled Input
```dart
TextInputWidget(
  controller: customController,
  hint: 'Custom input',
  label: 'Custom Field',
  borderRadius: 12.0,
  borderColor: Colors.blue,
  hintColor: Colors.grey.shade600,
  contentPadding: EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  ),
  validator: (value) => validation(
    context,
    type: TextFieldValidatorType.normalText,
    value: value ?? '',
  ),
)
```

## Theming

The widget respects the app's theme and uses:
- `Theme.of(context).textTheme.headlineMedium` for input text
- `Theme.of(context).textTheme.displaySmall` for hint and label text
- `AppColors.SECONDARY_COLOR` for cursor and focused border
- `AppColors.GREY_DARK_COLOR` for default borders and icons

## Accessibility

- Proper semantic markup for screen readers
- Keyboard navigation support
- Focus management
- Error announcement for validation messages

## Dependencies

- `flutter/material.dart`
- `flutter/services.dart`
- `flutter_screenutil` for responsive sizing
- `flutter_svg` for SVG icon support

## Best Practices

1. Always provide a `validator` function for form validation
2. Use appropriate `textInputType` for better user experience
3. Implement proper error handling in validation functions
4. Use consistent styling across the app
5. Provide meaningful hint and label text
6. Test with different screen sizes and orientations
7. Ensure accessibility compliance

## Migration Notes

When migrating from standard `TextFormField`:
1. Replace `TextFormField` with `TextInputWidget`
2. Update validation logic to use the provided validation function
3. Replace decoration properties with widget-specific styling properties
4. Update icon references to use SVG assets