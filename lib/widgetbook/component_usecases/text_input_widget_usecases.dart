import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../core/widget/text_input/input_formats.dart';
import '../../core/widget/text_input/text_field_validation.dart';
import '../../core/widget/text_input/text_input_widget.dart';
import '../flutter_markdown.dart';

// TextInputWidget Basic Use Case
@widgetbook.UseCase(
  name: 'Basic Text Input',
  type: TextInputWidget,
)
Widget basicTextInputWidget(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'Enter your text here',
        label: 'Basic Input',
        validator: (value) => validation(
          context,
          type: TextFieldValidatorType.normalText,
          value: value ?? '',
        ),
      ),
    ),
  );
}

// Card Expiry Input Use Case
@widgetbook.UseCase(
  name: 'Card Expiry Input',
  type: TextInputWidget,
)
Widget cardExpiryInputWidget(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'MM/YY',
        label: 'Expiry Date',
        textInputType: TextInputType.number,
        formatters: [
          FilteringTextInputFormatter.digitsOnly,
          CardExpireInputFormat(),
          LengthLimitingTextInputFormatter(5), // MM/YY
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Expiry date is required';
          }
          if (value.length != 5) {
            return 'Enter valid expiry date';
          }
          return null;
        },
      ),
    ),
  );
}

// Card Number Input Use Case
@widgetbook.UseCase(
  name: 'Card Number Input',
  type: TextInputWidget,
)
Widget cardNumberInputWidget(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'Enter card number',
        label: 'Card Number',
        textInputType: TextInputType.number,
        formatters: [
          FilteringTextInputFormatter.digitsOnly,
          CardInputFormat(),
          LengthLimitingTextInputFormatter(19), // 16 digits + 3 dashes
        ],
        prefixIcon: 'assets/icons/card_icon.svg', // تأكد من وجود الأيقونة
        validator: (value) => validation(
          context,
          type: TextFieldValidatorType.cardNumber,
          value: value?.replaceAll('-', '') ?? '',
        ),
      ),
    ),
  );
}

// Custom Styled Text Input Use Case
@widgetbook.UseCase(
  name: 'Custom Styled Text Input',
  type: TextInputWidget,
)
Widget customStyledTextInputWidget(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'Custom styled input',
        label: 'Custom Style',
        borderRadius: 12.0,
        borderColor: Colors.blue,
        hintColor: Colors.grey.shade600,
        hintFontSize: 14.0,
        labelFontSize: 12.0,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        validator: (value) => validation(
          context,
          type: TextFieldValidatorType.normalText,
          value: value ?? '',
        ),
      ),
    ),
  );
}

// CVC Input Use Case
@widgetbook.UseCase(
  name: 'CVC Input',
  type: TextInputWidget,
)
Widget cvcInputWidget(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'CVC',
        label: 'CVC',
        textInputType: TextInputType.number,
        formatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        validator: (value) => validation(
          context,
          type: TextFieldValidatorType.cvc,
          value: value ?? '',
        ),
      ),
    ),
  );
}

// Disabled Text Input Use Case
@widgetbook.UseCase(
  name: 'Disabled Text Input',
  type: TextInputWidget,
)
Widget disabledTextInputWidget(BuildContext context) {
  final controller = TextEditingController(text: 'This field is disabled');

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'Disabled field',
        label: 'Disabled Input',
        enabled: false,
        validator: (value) => null,
      ),
    ),
  );
}

// Email Input Use Case
@widgetbook.UseCase(
  name: 'Email Input',
  type: TextInputWidget,
)
Widget emailInputWidget(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'Enter your email',
        label: 'Email Address',
        textInputType: TextInputType.emailAddress,
        prefixIcon: 'assets/icons/email_icon.svg', // تأكد من وجود الأيقونة
        validator: (value) => validation(
          context,
          type: TextFieldValidatorType.email,
          value: value ?? '',
        ),
      ),
    ),
  );
}

// Email or Phone Input Use Case
@widgetbook.UseCase(
  name: 'Email or Phone Input',
  type: TextInputWidget,
)
Widget emailOrPhoneInputWidget(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'Enter email or phone number',
        label: 'Email or Phone',
        textInputType: TextInputType.text,
        validator: (value) => validation(
          context,
          type: TextFieldValidatorType.emailOrPhoneNumber,
          value: value ?? '',
        ),
      ),
    ),
  );
}

// Multi-line Text Input Use Case
@widgetbook.UseCase(
  name: 'Multi-line Text Input',
  type: TextInputWidget,
)
Widget multilineTextInputWidget(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'Enter your message here...',
        label: 'Message',
        maxLines: 5,
        textInputType: TextInputType.multiline,
        validator: (value) => validation(
          context,
          type: TextFieldValidatorType.normalText,
          value: value ?? '',
        ),
      ),
    ),
  );
}

// Name Input Use Case
@widgetbook.UseCase(
  name: 'Name Input',
  type: TextInputWidget,
)
Widget nameInputWidget(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'Enter your full name',
        label: 'Full Name',
        textInputType: TextInputType.name,
        prefixIcon: 'assets/icons/person_icon.svg', // تأكد من وجود الأيقونة
        validator: (value) => validation(
          context,
          type: TextFieldValidatorType.name,
          value: value ?? '',
        ),
      ),
    ),
  );
}

// Number Input Use Case
@widgetbook.UseCase(
  name: 'Number Input',
  type: TextInputWidget,
)
Widget numberInputWidget(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'Enter a number',
        label: 'Number',
        textInputType: TextInputType.number,
        formatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) => validation(
          context,
          type: TextFieldValidatorType.number,
          value: value ?? '',
        ),
      ),
    ),
  );
}

// Optional Text Input Use Case
@widgetbook.UseCase(
  name: 'Optional Text Input',
  type: TextInputWidget,
)
Widget optionalTextInputWidget(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'This field is optional',
        label: 'Optional Field',
        validator: (value) => validation(
          context,
          type: TextFieldValidatorType.optional,
          value: value ?? '',
        ),
      ),
    ),
  );
}

// Password Input Use Case
@widgetbook.UseCase(
  name: 'Password Input',
  type: TextInputWidget,
)
Widget passwordInputWidget(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'Enter your password',
        label: 'Password',
        isPassword: true,
        prefixIcon: 'assets/icons/lock_icon.svg', // تأكد من وجود الأيقونة
        suffixSvg: 'assets/icons/eye_icon.svg', // تأكد من وجود الأيقونة
        validator: (value) => validation(
          context,
          type: TextFieldValidatorType.password,
          value: value ?? '',
        ),
      ),
    ),
  );
}

// Phone Number Input Use Case
@widgetbook.UseCase(
  name: 'Phone Number Input',
  type: TextInputWidget,
)
Widget phoneInputWidget(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'Enter phone number',
        label: 'Phone Number',
        textInputType: TextInputType.phone,
        formatters: [MobilePhoneInputFormat()],
        prefixIcon: 'assets/icons/phone_icon.svg', // تأكد من وجود الأيقونة
        validator: (value) => validation(
          context,
          type: TextFieldValidatorType.phoneNumber,
          value: value ?? '',
        ),
      ),
    ),
  );
}

// Read Only Text Input Use Case
@widgetbook.UseCase(
  name: 'Read Only Text Input',
  type: TextInputWidget,
)
Widget readOnlyTextInputWidget(BuildContext context) {
  final controller = TextEditingController(text: 'This is read only');

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: 'Read only field',
        label: 'Read Only Input',
        readOnly: true,
        validator: (value) => null,
      ),
    ),
  );
}

// TextInputWidget Documentation
@widgetbook.UseCase(
  name: 'TextInputWidget Documentation',
  type: MarkdownViewer,
)
MarkdownViewer textInputWidgetDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/TextInputWidgetDoc.md',
  );
}
