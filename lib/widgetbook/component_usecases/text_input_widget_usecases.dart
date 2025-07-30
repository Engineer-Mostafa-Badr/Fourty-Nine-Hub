import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../core/widget/text_input/input_formats.dart';
import '../../core/widget/text_input/text_field_validation.dart';
import '../../core/widget/text_input/text_input_widget.dart';
import '../flutter_markdown.dart';

// Basic Text Input مع Knobs
@widgetbook.UseCase(
  name: 'Basic Text Input with Knobs',
  type: TextInputWidget,
)
Widget basicTextInputWidget(BuildContext context) {
  final controller = TextEditingController();

  // استخدام الـ knobs للتحكم في الخصائص
  final hint = context.knobs.string(
    label: 'Hint Text',
    initialValue: 'Enter your text here',
  );

  final label = context.knobs.string(
    label: 'Label Text',
    initialValue: 'Basic Input',
  );

  final enabled = context.knobs.boolean(
    label: 'Enabled',
    initialValue: true,
  );

  final readOnly = context.knobs.boolean(
    label: 'Read Only',
    initialValue: false,
  );

  final borderRadius = context.knobs.double.slider(
    label: 'Border Radius',
    initialValue: 8.0,
    min: 0.0,
    max: 24.0,
  );

  final maxLines = context.knobs.int.slider(
    label: 'Max Lines',
    initialValue: 1,
    min: 1,
    max: 10,
  );

  return WidgetbookScreenUtilFormWrapper(
    child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextInputWidget(
          controller: controller,
          hint: hint,
          label: label,
          enabled: enabled,
          readOnly: readOnly,
          borderRadius: borderRadius,
          maxLines: maxLines,
          validator: (value) => validation(
            context,
            type: TextFieldValidatorType.normalText,
            value: value ?? '',
          ),
        ),
      ),
    ),
  );
}

// Card Number Input مع Knobs
@widgetbook.UseCase(
  name: 'Card Number Input with Knobs',
  type: TextInputWidget,
)
Widget cardNumberInputWidget(BuildContext context) {
  final controller = TextEditingController();

  final hint = context.knobs.string(
    label: 'Hint Text',
    initialValue: 'Enter card number',
  );

  final label = context.knobs.string(
    label: 'Label Text',
    initialValue: 'Card Number',
  );

  final showPrefixIcon = context.knobs.boolean(
    label: 'Show Card Icon',
    initialValue: true,
  );

  final maxLength = context.knobs.list(
    label: 'Card Format',
    options: [19, 17, 21],
    labelBuilder: (length) {
      if (length == 19) return 'Standard (19 chars)';
      if (length == 17) return 'Amex (17 chars)';
      if (length == 21) return 'Custom (21 chars)';
      return 'Unknown';
    },
  );

  final borderRadius = context.knobs.double.slider(
    label: 'Border Radius',
    initialValue: 8.0,
    min: 0.0,
    max: 20.0,
  );

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: WidgetbookScreenUtilFormWrapper(
        child: TextInputWidget(
          controller: controller,
          hint: hint,
          label: label,
          textInputType: TextInputType.number,
          borderRadius: borderRadius,
          formatters: [
            FilteringTextInputFormatter.digitsOnly,
            CardInputFormat(),
            LengthLimitingTextInputFormatter(maxLength),
          ],
          prefixIcon: showPrefixIcon ? 'assets/icons/card_icon.svg' : null,
          validator: (value) => validation(
            context,
            type: TextFieldValidatorType.cardNumber,
            value: value?.replaceAll('-', '') ?? '',
          ),
        ),
      ),
    ),
  );
}

// Custom Styled Text Input مع Knobs متقدمة
@widgetbook.UseCase(
  name: 'Custom Styled Text Input with Advanced Knobs',
  type: TextInputWidget,
)
Widget customStyledTextInputWidget(BuildContext context) {
  final controller = TextEditingController();

  // Text knobs
  final hint = context.knobs.string(
    label: 'Hint Text',
    initialValue: 'Custom styled input',
  );

  final label = context.knobs.string(
    label: 'Label Text',
    initialValue: 'Custom Style',
  );

  // Style knobs
  final borderRadius = context.knobs.double.slider(
    label: 'Border Radius',
    initialValue: 12.0,
    min: 0.0,
    max: 30.0,
  );

  // Color knobs
  final borderColor = context.knobs.list(
    label: 'Border Color',
    options: [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange
    ],
    labelBuilder: (color) {
      if (color == Colors.blue) return 'Blue';
      if (color == Colors.red) return 'Red';
      if (color == Colors.green) return 'Green';
      if (color == Colors.purple) return 'Purple';
      if (color == Colors.orange) return 'Orange';
      return 'Unknown';
    },
  );

  final hintColor = context.knobs.list(
    label: 'Hint Color',
    options: [
      Colors.grey.shade600,
      Colors.grey.shade400,
      Colors.grey.shade800,
      Colors.blueGrey
    ],
    labelBuilder: (color) {
      if (color == Colors.grey.shade600) return 'Grey 600';
      if (color == Colors.grey.shade400) return 'Grey 400';
      if (color == Colors.grey.shade800) return 'Grey 800';
      if (color == Colors.blueGrey) return 'Blue Grey';
      return 'Unknown';
    },
  );

  // Font size knobs
  final hintFontSize = context.knobs.double.slider(
    label: 'Hint Font Size',
    initialValue: 14.0,
    min: 10.0,
    max: 20.0,
  );

  final labelFontSize = context.knobs.double.slider(
    label: 'Label Font Size',
    initialValue: 12.0,
    min: 8.0,
    max: 18.0,
  );

  // Padding knobs
  final horizontalPadding = context.knobs.double.slider(
    label: 'Horizontal Padding',
    initialValue: 16.0,
    min: 8.0,
    max: 32.0,
  );

  final verticalPadding = context.knobs.double.slider(
    label: 'Vertical Padding',
    initialValue: 12.0,
    min: 6.0,
    max: 24.0,
  );

  // Boolean knobs
  final enabled = context.knobs.boolean(
    label: 'Enabled',
    initialValue: true,
  );

  final readOnly = context.knobs.boolean(
    label: 'Read Only',
    initialValue: false,
  );

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: WidgetbookScreenUtilFormWrapper(
        child: TextInputWidget(
          controller: controller,
          hint: hint,
          label: label,
          enabled: enabled,
          readOnly: readOnly,
          borderRadius: borderRadius,
          borderColor: borderColor,
          hintColor: hintColor,
          hintFontSize: hintFontSize,
          labelFontSize: labelFontSize,
          contentPadding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          validator: (value) => validation(
            context,
            type: TextFieldValidatorType.normalText,
            value: value ?? '',
          ),
        ),
      ),
    ),
  );
}

// Email Input مع Knobs
@widgetbook.UseCase(
  name: 'Email Input with Knobs',
  type: TextInputWidget,
)
Widget emailInputWidget(BuildContext context) {
  final controller = TextEditingController();

  final hint = context.knobs.string(
    label: 'Hint Text',
    initialValue: 'Enter your email',
  );

  final label = context.knobs.string(
    label: 'Label Text',
    initialValue: 'Email Address',
  );

  final showPrefixIcon = context.knobs.boolean(
    label: 'Show Email Icon',
    initialValue: true,
  );

  final borderRadius = context.knobs.double.slider(
    label: 'Border Radius',
    initialValue: 8.0,
    min: 0.0,
    max: 20.0,
  );

  final validationType = context.knobs.list(
    label: 'Validation Type',
    options: [
      TextFieldValidatorType.email,
      TextFieldValidatorType.emailOrPhoneNumber,
      TextFieldValidatorType.optional,
    ],
    labelBuilder: (type) {
      if (type == TextFieldValidatorType.email) return 'Email';
      if (type == TextFieldValidatorType.emailOrPhoneNumber)
        return 'Email or Phone';
      if (type == TextFieldValidatorType.optional) return 'Optional';
      return 'Unknown';
    },
  );

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextInputWidget(
        controller: controller,
        hint: hint,
        label: label,
        textInputType: TextInputType.emailAddress,
        borderRadius: borderRadius,
        prefixIcon: showPrefixIcon ? 'assets/icons/email_icon.svg' : null,
        validator: (value) => validation(
          context,
          type: validationType,
          value: value ?? '',
        ),
      ),
    ),
  );
}

// Multi-line Text Input مع Knobs
@widgetbook.UseCase(
  name: 'Multi-line Text Input with Knobs',
  type: TextInputWidget,
)
Widget multilineTextInputWidget(BuildContext context) {
  final controller = TextEditingController();

  final hint = context.knobs.string(
    label: 'Hint Text',
    initialValue: 'Enter your message here...',
  );

  final label = context.knobs.string(
    label: 'Label Text',
    initialValue: 'Message',
  );

  final maxLines = context.knobs.int.slider(
    label: 'Max Lines',
    initialValue: 5,
    min: 2,
    max: 10,
  );

  final borderRadius = context.knobs.double.slider(
    label: 'Border Radius',
    initialValue: 8.0,
    min: 0.0,
    max: 20.0,
  );

  final minLines = context.knobs.int.slider(
    label: 'Min Lines',
    initialValue: 3,
    min: 1,
    max: 5,
  );

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: WidgetbookScreenUtilFormWrapper(
        child: TextInputWidget(
          controller: controller,
          hint: hint,
          label: label,
          maxLines: maxLines,
          // minLines: minLines,
          textInputType: TextInputType.multiline,
          borderRadius: borderRadius,
          validator: (value) => validation(
            context,
            type: TextFieldValidatorType.normalText,
            value: value ?? '',
          ),
        ),
      ),
    ),
  );
}

// Password Input مع Knobs
@widgetbook.UseCase(
  name: 'Password Input with Knobs',
  type: TextInputWidget,
)
Widget passwordInputWidget(BuildContext context) {
  final controller = TextEditingController();

  final hint = context.knobs.string(
    label: 'Hint Text',
    initialValue: 'Enter your password',
  );

  final label = context.knobs.string(
    label: 'Label Text',
    initialValue: 'Password',
  );

  final showPrefixIcon = context.knobs.boolean(
    label: 'Show Prefix Icon',
    initialValue: true,
  );

  final showSuffixIcon = context.knobs.boolean(
    label: 'Show Suffix Icon',
    initialValue: true,
  );

  final borderRadius = context.knobs.double.slider(
    label: 'Border Radius',
    initialValue: 8.0,
    min: 0.0,
    max: 20.0,
  );

  final validationType = context.knobs.list(
    label: 'Validation Type',
    options: [
      TextFieldValidatorType.password,
      TextFieldValidatorType.password,
      TextFieldValidatorType.optional,
    ],
    labelBuilder: (type) {
      if (type == TextFieldValidatorType.password) return 'Password';
      if (type == TextFieldValidatorType.password) return 'Strong Password';
      if (type == TextFieldValidatorType.optional) return 'Optional';
      return 'Unknown';
    },
  );

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: WidgetbookScreenUtilFormWrapper(
        child: TextInputWidget(
          controller: controller,
          hint: hint,
          label: label,
          isPassword: true,
          borderRadius: borderRadius,
          prefixIcon: showPrefixIcon ? 'assets/icons/lock_icon.svg' : null,
          suffixSvg: showSuffixIcon ? 'assets/icons/eye_icon.svg' : null,
          validator: (value) => validation(
            context,
            type: validationType,
            value: value ?? '',
          ),
        ),
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
    markdownFilePath: 'assets/markdown/docs/MigrationAndUpdates.md',
  );
}

class WidgetbookScreenUtilFormWrapper extends StatelessWidget {
  final Widget child;
  final Size? designSize;

  const WidgetbookScreenUtilFormWrapper({
    super.key,
    required this.child,
    this.designSize = const Size(375, 812),
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: designSize!,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => Form(child: child),
    );
  }
}

class WidgetbookScreenUtilWrapper extends StatelessWidget {
  final Widget child;
  final Size? designSize;

  const WidgetbookScreenUtilWrapper({
    super.key,
    required this.child,
    this.designSize = const Size(375, 812),
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: designSize!,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => child,
    );
  }
}
