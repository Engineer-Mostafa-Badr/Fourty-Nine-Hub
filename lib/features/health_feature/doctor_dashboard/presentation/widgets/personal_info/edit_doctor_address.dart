import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

class EditDoctorAddressField extends StatelessWidget {
  const EditDoctorAddressField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownMenu(
          width: MediaQuery.of(context).size.width * 0.9,
          hintText: Labels.governorate,
          dropdownMenuEntries: const [],
          onSelected: (value) {
            if (value != null) {}
          },
        ),
        const Sizer(height: 20,),
        DropdownMenu(
          width: MediaQuery.of(context).size.width * 0.9,
          hintText: Labels.city,
          dropdownMenuEntries: const [],
          onSelected: (value) {
            if (value != null) {}
          },
        ),
        const Sizer(height: 20,),
        DefaultTextFormField(
          hint: Labels.address,
          keyboardType: TextInputType.text,
          isRequired: true,
          currentFocusNode: FocusNode(),
          currentController: TextEditingController(),
        ),
      ],
    );
  }
}
