import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_personal_info/edit_doctor_personal_info_cubit.dart';

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
            currentController: context.read<EditDoctorPersonalInfoCubit>().firstNameController,
            nextFocusNode: FocusNode(),
          ),
        ),
        const Sizer(),
        Expanded(
          child: LastNameTextFormField(
            currentFocusNode: FocusNode(),
            currentController: context.read<EditDoctorPersonalInfoCubit>().lastNameController,
            nextFocusNode: FocusNode(),
          ),
        ),
      ],
    );
  }
}
