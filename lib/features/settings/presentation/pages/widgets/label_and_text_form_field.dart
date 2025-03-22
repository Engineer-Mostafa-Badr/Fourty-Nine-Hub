import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class LabelAndTextFormField extends StatelessWidget {
  const LabelAndTextFormField(
      {super.key,
      required this.label,
      required this.controller,
      required this.hint});

  final String label, hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 11),
          child: Label(
            text: label,
            style: Styles.mediumText(fontSize: 26),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        DefaultTextFormField(
          currentController: controller,
          hint: hint,
        ),
      ],
    );
  }
}
