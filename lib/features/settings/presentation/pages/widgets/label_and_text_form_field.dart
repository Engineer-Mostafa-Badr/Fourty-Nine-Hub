import 'package:flutter/material.dart';
import '../../../../../common/widgets/form/text_fields/default_text_form_field.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class LabelAndTextFormField extends StatelessWidget {
  const LabelAndTextFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.focusNodeCurrent,
    this.focusNodeNext,
    this.textInputAction,
  });

  final String label, hint;
  final TextEditingController controller;
  final FocusNode? focusNodeCurrent;
  final FocusNode? focusNodeNext;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 11),
          child: Label(
            text: label,
            style: Styles.mediumText(
              fontSize: 26,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        DefaultTextFormField(
          currentController: controller,
          hint: hint,
          borderColor:
              context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
          currentFocusNode: focusNodeCurrent,
          nextFocusNode: focusNodeNext,
          textInputAction: textInputAction,
        ),
      ],
    );
  }
}
