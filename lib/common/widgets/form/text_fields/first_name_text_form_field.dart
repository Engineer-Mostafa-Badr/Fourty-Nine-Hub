import 'package:flutter/material.dart';

import '../../../../core/utils/validator.dart';
import '../../../../res/style/app_colors.dart';
import 'abstract/main_text_form_field.dart';

class FirstNameTextFormField extends MainTextFormField {
  FirstNameTextFormField({
    super.key,
    required super.currentFocusNode,
    required FocusNode super.nextFocusNode,
    required super.currentController,
    super.margin = null,
    super.enabled,
    super.maxLength,
    super.hintColor,
    super.fillColor,
  }) : super(
          validator: Validator().validateUserName,
          hintText: 'First Name',
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          borderColor: AppColors.GREY_DARK_COLOR,
        );
}
