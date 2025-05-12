import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/validator.dart';
import 'abstract/main_text_form_field.dart';

class EmailTextFormField extends MainTextFormField {
  EmailTextFormField({
    super.key,
    super.currentFocusNode,
    super.nextFocusNode,
    required super.currentController,
    required final String hint,
    super.keyboardType,
    super.contentPadding,
    super.style,
    super.onTap,
    super.isAuthentcation,
    super.labelWidget,
    super.label,
    super.prefix,
    super.enabled,
    super.readOnly,
    super.margin = null,
    super.noBoarder,
    final bool isRequired = false,
    super.expanded,
    Color super.borderColor = Colors.black,
    final List<TextInputFormatter>? inputFormatter,
    super.maxLines,
    super.minLines,
    super.obscureText,
    super.fillColor,
    final int? maxLength,
    super.suffixIcon,
    super.prefixIcon,
    final String? Function(String?)? validator,
    super.onChanged,
    super.constraints,
    super.hintColor,
    super.hintStyle,
  }) : super(
          validator: (v) =>
              validator?.call(v) ?? (isRequired ? validatorEmail(v) : null),
          hintText: hint + (isRequired ? '*' : ''),
          textCapitalization: TextCapitalization.words,
          inputFormatters: inputFormatter,
        );
}
