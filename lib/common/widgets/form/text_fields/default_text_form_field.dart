import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/validator.dart';
import 'abstract/main_text_form_field.dart';

class DefaultTextFormField extends MainTextFormField {
  DefaultTextFormField({
    super.key,
    super.currentFocusNode,
    super.nextFocusNode,
    required super.currentController,
    required final String hint,
    TextInputType super.keyboardType = TextInputType.text,
    super.margin = null,
    super.contentPadding,
    super.onTap,
    super.enabled,
    super.readOnly,
    final bool isRequired = false,
    super.expanded,
    Color super.borderColor = Colors.black,
    final List<TextInputFormatter>? inputFormatter,
    super.maxLines,
    super.minLines,
    super.obscureText,
    final int? maxLength,
    super.suffixIcon,
    prefixIcon,
    final String? Function(String?)? validator,
    super.onChanged,
    super.label,
    Color? hintColor,
  }) : super(
          validator: validator ?? (isRequired ? Validator().validateEmptyField : null),
          hintText: hint + (isRequired ? '*' : ''),
          textCapitalization: TextCapitalization.words,
          maxLength: maxLines,
          prefixIcon: prefixIcon,
          inputFormatters: inputFormatter,
        );
}
