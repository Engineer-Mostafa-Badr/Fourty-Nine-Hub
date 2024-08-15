import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/validator.dart';
import 'abstract/main_text_form_field.dart';

class DefaultTextFormField extends MainTextFormField {
  DefaultTextFormField({
    Key? key,
    required final FocusNode currentFocusNode,
    final FocusNode? nextFocusNode,
    required final TextEditingController currentController,
    required final String hint,
    final TextInputType keyboardType = TextInputType.text,
    final EdgeInsetsGeometry? margin,
    final EdgeInsetsGeometry? contentPadding,
    final VoidCallback? onTap,
    final bool enabled = true,
    final bool isRequired = false,
    final bool expanded = false,
    final bool readOnly = false,
    final Color borderColor = Colors.black,
    final List<TextInputFormatter>? inputFormatter,
    final int? maxLines,
    final int? minLines,
    final bool? obscureText,
    final int? maxLength,
    final Widget? suffixIcon,
    final Color? hintColor,
    prefixIcon,
    final String? Function(String?)? validator,
    final ValueChanged<String>? onChanged,
  }) : super(
          key: key,
          currentController: currentController,
          currentFocusNode: currentFocusNode,
          nextFocusNode: nextFocusNode,
          minLines: minLines,
          validator:
              validator ?? (isRequired ? Validator().validateEmptyField : null),
          hintText: hint + (isRequired ? '*' : ''),
          hintColor: hintColor,
          keyboardType: keyboardType,
          margin: margin,
          onTap: onTap,
          textCapitalization: TextCapitalization.words,
          enabled: enabled,
          readOnly: readOnly,
          expanded: expanded,
          maxLines: maxLines,
          borderColor: borderColor,
          maxLength: maxLines,
          obscureText: obscureText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          contentPadding: contentPadding,
          onChanged: onChanged,
          inputFormatters: inputFormatter,
        );
}
