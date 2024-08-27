import 'package:flutter/material.dart';

import '../../../../core/utils/validator.dart';
import '../../../../res/style/app_colors.dart';
import 'abstract/main_text_form_field.dart';

class LastNameTextFormField extends MainTextFormField {
  LastNameTextFormField(
      {super.key,
      super.currentFocusNode,
      super.nextFocusNode,
      required super.currentController,
      super.margin = null,
      super.enabled,
      super.maxLength,
      String? Function(String?)? validator,
      super.hintColor,
      super.fillColor})
      : super(
          validator: validator ?? Validator().validateUserName,
          hintText: 'Last Name',
          // border
          keyboardType: TextInputType.name,
          borderColor: Colors.black,
          textCapitalization: TextCapitalization.words,
        );
}
