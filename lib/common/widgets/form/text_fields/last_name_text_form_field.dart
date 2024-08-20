import 'package:flutter/material.dart';

import '../../../../core/utils/validator.dart';
import '../../../../res/style/app_colors.dart';
import 'abstract/main_text_form_field.dart';

class LastNameTextFormField extends MainTextFormField {
  LastNameTextFormField(
      {super.key,
      required super.currentFocusNode,
      super.nextFocusNode,
      required super.currentController,
      super.margin = null,
      super.enabled,
      super.maxLength,
      super.hintColor,
      super.fillColor})
      : super(
          validator: Validator().validateUserName,
          hintText: 'Last Name',
          keyboardType: TextInputType.name,
          borderColor: AppColors.GREY_DARK_COLOR,
          textCapitalization: TextCapitalization.words,
        );
}
