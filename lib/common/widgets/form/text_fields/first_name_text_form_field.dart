import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/validator.dart';
import '../../../../res/style/app_colors.dart';
import 'abstract/main_text_form_field.dart';

class FirstNameTextFormField extends MainTextFormField {
  FirstNameTextFormField({
    super.key,
    super.currentFocusNode,
    FocusNode? super.nextFocusNode,
    required super.currentController,
    super.margin = null,
    super.enabled,
    super.maxLength,
    // super.
    String? Function(String?)? validator,
    super.style,
    super.hintColor,
    super.fillColor,
  }) : super(
    // style: ,
          validator: validator??Validator().validateUserName,
          hintText: LocaleKeys.firstName.localize,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          borderColor: Colors.black,
        );
}
