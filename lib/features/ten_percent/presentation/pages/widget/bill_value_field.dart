import 'package:flutter/material.dart';
import '../../../../../common/widgets/form/text_fields/abstract/main_text_form_field.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/validator.dart';
import '../../../../../res/style/app_colors.dart';

class BillValueTextFormField extends MainTextFormField {
  @override
  final String? Function(String?)? validator;

  BillValueTextFormField({
    super.key,
    this.validator,
    super.currentFocusNode,
    super.nextFocusNode,
    required super.currentController,
    super.margin = null,
    super.enabled,
    super.maxLength,
    super.hintColor,
    super.fillColor,
  }) : super(
          validator: validator ?? Validator().validateEmptyValue,
          hintText: LocaleKeys.billValue.localize,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.words,
          borderColor: AppColors.GREY_DARK_COLOR,
        );
}
