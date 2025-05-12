import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/validator.dart';
import 'abstract/main_text_form_field.dart';

class NewPhoneNumberTextFormField extends MainTextFormField {
  NewPhoneNumberTextFormField({
    super.key,
    super.currentFocusNode,
    super.nextFocusNode,
    required super.currentController,
    super.keyboardType = TextInputType.phone,
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
    super.borderColor = Colors.black,
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
    FocusNode? focusNode,
  }) : super(
          validator: (v) =>
              validator?.call(v) ?? (isRequired ? validatorPhone(v) : null),
          hintText: LocaleKeys.phoneNumber.localize + (isRequired ? '*' : ''),
          textCapitalization: TextCapitalization.words,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        );
}
