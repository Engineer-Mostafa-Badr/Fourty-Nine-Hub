import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../core/utils/validator.dart';
import 'abstract/main_text_form_field.dart';

class LastNameTextFormField extends MainTextFormField {
  LastNameTextFormField(
      {super.key,
      super.currentFocusNode,
      super.nextFocusNode,
      required super.currentController,
      super.isAuthentcation,
      super.margin = null,
      super.enabled,
      super.maxLength,
      String? Function(String?)? validator,
      super.hintColor,
      super.onChanged,
      super.fillColor})
      : super(
          validator: validator ?? Validator().validateUserName,
          hintText: LocaleKeys.lastName.tr(),
          // border
          keyboardType: TextInputType.name,
          borderColor: Colors.black,
          textCapitalization: TextCapitalization.words,
        );
}
