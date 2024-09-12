import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';

class CreateDoctorNameField extends StatelessWidget {
  const CreateDoctorNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorLoginCubit = context.read<CreateDoctorCubit>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FirstNameTextFormField(
            currentFocusNode: doctorLoginCubit.firstNameFocusNode,
            currentController: doctorLoginCubit.firstNameController,
            nextFocusNode: doctorLoginCubit.lastNameFocusNode,
          ),
        ),
        Sizer(),
        Expanded(
          child: LastNameTextFormField(
            currentFocusNode: doctorLoginCubit.lastNameFocusNode,
            currentController: doctorLoginCubit.lastNameController,
            nextFocusNode: doctorLoginCubit.phoneFocusNode,
          ),
        ),
      ],
    );
  }
}
