import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_personal_info/edit_doctor_personal_info_cubit.dart';

import '../../../../../../common/widgets/form/text_fields/new_phone_number_text_field.dart';

class EditDoctorPhoneField extends StatelessWidget {
  const EditDoctorPhoneField({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.isDarkMode ? Colors.white : Colors.black) ??
        TextStyle(color: context.isDarkMode ? Colors.white : Colors.black);
    return NewPhoneNumberTextFormField(
      focusNode: FocusNode(),
      currentController: context.read<EditDoctorPersonalInfoCubit>().phoneController,
      // enabled: widget.isEnabled,
      style: textStyle,
      isRequired: true,
      maxLength: 15,
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        print(context.read<EditDoctorPersonalInfoCubit>().phoneController.text);
      },
    );
  }
}
