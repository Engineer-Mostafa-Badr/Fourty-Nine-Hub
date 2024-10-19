import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

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
          hintText: LocaleKeys.lastName.tr(),
          keyboardType: TextInputType.emailAddress,
          borderColor: borderColor ?? AppColors.GREY_DARK_COLOR,
          inputFormatters: [
            FilteringTextInputFormatter.deny(
              RegExp(r" "),
            ),
          ],
        );
}
