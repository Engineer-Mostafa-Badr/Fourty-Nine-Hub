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
    // Key? key,
    // final FocusNode? currentFocusNode,
    // final FocusNode? nextFocusNode,
    // required final TextEditingController currentController,
    required final String hint,

    super.keyboardType,
    // super.margin = null,
    // super.contentPadding,
    super.style,
    super.onTap,
    super.isAuthentcation,
    super.labelWidget,
    super.label,
    super.prefix,
    // super.
    super.enabled,
    super.readOnly,
    // final TextInputType keyboardType = TextInputType.text,
    super.margin = null,
    final EdgeInsetsGeometry? contentPadding,
    // final VoidCallback? onTap,
    // final bool enabled = true,
    // final bool readOnly = false,
    super.noBoarder,
    final bool isRequired = false,
    super.expanded,
    Color super.borderColor = Colors.black,
    final List<TextInputFormatter>? inputFormatter,
    super.maxLines,
    super.minLines,
    super.obscureText,
    // final int? maxLines,
    // final int? minLines,
    // super.constraints,
    final String? lable,
    super.fillColor,
    // super.hintFontSize,
    // final bool? obscureText,
    final int? maxLength,
    super.suffixIcon,
    prefixIcon,
    final String? Function(String?)? validator,
    super.onChanged,
    // super.label,
    super.constraints,
    super.hintColor,
    // final ValueChanged<String>? onChanged,
    // Color? hintColor,
  }) : super(
          // key: key,
          // currentController: currentController,
          // readOnly: readOnly,
          validator:
              validator ?? (isRequired ? Validator().validateEmptyField : null),
          hintText: hint + (isRequired ? '*' : ''),
          textCapitalization: TextCapitalization.words,
          // maxLines: maxLines,
          // suffixIcon: suffixIcon,

          prefixIcon: prefixIcon,
          inputFormatters: inputFormatter,
        );
}
