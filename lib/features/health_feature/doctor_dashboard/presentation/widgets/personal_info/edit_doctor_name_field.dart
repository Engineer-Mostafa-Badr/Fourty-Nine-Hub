import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';

class EditDoctorNameField extends StatelessWidget {
  const EditDoctorNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FirstNameTextFormField(
            currentFocusNode: FocusNode(),
            currentController: TextEditingController(),
            nextFocusNode: FocusNode(),
          ),
        ),
        const Sizer(),
        Expanded(
          child: LastNameTextFormField(
            currentFocusNode: FocusNode(),
            currentController: TextEditingController(),
            nextFocusNode: FocusNode(),
          ),
        ),
      ],
    );
  }
}
