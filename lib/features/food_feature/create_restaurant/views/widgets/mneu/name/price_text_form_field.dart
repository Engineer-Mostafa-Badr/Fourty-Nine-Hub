import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/abstract/main_text_form_field.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/validator.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class PriceTextFormField extends MainTextFormField {
  PriceTextFormField({
    super.key,
    super.currentFocusNode,
    super.nextFocusNode,
    required super.currentController,
    super.margin = null,
    super.enabled,
    super.maxLength,
    super.hintColor,
    super.fillColor,
  }) : super(
          validator: Validator().validateEmptyValue,
          hintText: LocaleKeys.price.tr(),
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.words,
          borderColor: AppColors.GREY_DARK_COLOR,
        );
}
