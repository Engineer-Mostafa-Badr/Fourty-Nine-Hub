import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/abstract/main_text_form_field.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/validator.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class FoodNameTextFormField extends MainTextFormField {
  FoodNameTextFormField({
    super.key,
    super.currentFocusNode,
    super.nextFocusNode,
    required super.currentController,
    super.margin = null,
    super.enabled,
    super.maxLength,
    super.fillColor,
    Color? hintColor,
  }) : super(
          validator: Validator().validateUserName,
          hintColor: hintColor ?? Colors.grey,
          hintText: LocaleKeys.itemName.tr(),
          textCapitalization: TextCapitalization.words,
          borderColor: AppColors.GREY_DARK_COLOR,
        );
}
