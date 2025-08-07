import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../res/style/app_colors.dart';
import 'abstract/main_text_form_field.dart';

class SearchTextFormField extends MainTextFormField {
  SearchTextFormField({
    super.key,
    required super.currentFocusNode,
    required super.currentController,
    super.margin,
    String? hint,
    super.enabled,
    super.style,
    super.borderColor,
    super.hintStyle,
    Color? hintColor,
    SvgPicture? icon,
    super.cursorColor = AppColors.ACCENT_COLOR,
    super.fillColor = Colors.white,
    super.onEditComplete,
    super.onChanged,
  }) : super(
          hintText: hint ?? '',
          keyboardType: TextInputType.emailAddress,
          validator: null,
          hintColor: hintColor ?? AppColors.PRIMARY_COLOR_DARK,
          prefixIcon:
              Icon(Icons.search, color: hintColor ?? AppColors.QUANTITY_COLOR),
          suffixIcon: icon,
        );
}
