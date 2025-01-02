import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/abstract/main_text_form_field.dart';
import 'package:fourtyninehub/core/utils/validator.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

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
          hintText: 'Invoice value',
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.words,
          borderColor: AppColors.GREY_DARK_COLOR,
        );
}
