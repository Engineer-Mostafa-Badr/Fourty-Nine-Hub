import 'package:flutter/services.dart';

import '../../../../core/utils/validator.dart';
import '../../../../res/style/app_colors.dart';
import 'abstract/main_text_form_field.dart';

class EmailTextFormField extends MainTextFormField {
  EmailTextFormField({
    super.key,
    required super.currentFocusNode,
    super.nextFocusNode,
    required super.currentController,
    super.margin = null,
    super.hintColor,
    super.fillColor,
    final Color? borderColor,
    super.enabled,
  }) : super(
          validator: Validator().validateEmail,
          hintText: 'Email Address',
          keyboardType: TextInputType.emailAddress,
          borderColor: borderColor ?? AppColors.GREY_DARK_COLOR,
          inputFormatters: [
            FilteringTextInputFormatter.deny(
              RegExp(r" "),
            ),
          ],
        );
}
