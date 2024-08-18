import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

import '../../../../../../core/localization/locale_keys.g.dart';

class EditDoctorAddressField extends StatelessWidget {
  const EditDoctorAddressField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownMenu(
          width: MediaQuery.of(context).size.width * 0.9,
          hintText: LocaleKeys.governorate.localize,
          dropdownMenuEntries: const [],
          onSelected: (value) {
            if (value != null) {}
          },
        ),
        const Sizer(
          height: 20,
        ),
        DropdownMenu(
          width: MediaQuery.of(context).size.width * 0.9,
          hintText: LocaleKeys.city.localize,
          dropdownMenuEntries: const [],
          onSelected: (value) {
            if (value != null) {}
          },
        ),
        const Sizer(
          height: 20,
        ),
        DefaultTextFormField(
          hint: LocaleKeys.address.localize,
          keyboardType: TextInputType.text,
          isRequired: true,
          currentFocusNode: FocusNode(),
          currentController: TextEditingController(),
        ),
      ],
    );
  }
}
