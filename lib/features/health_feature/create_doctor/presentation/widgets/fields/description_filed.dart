import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';

class CreateDoctorDescriptionField extends StatelessWidget {
  const CreateDoctorDescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      hint: 'Desciption',
      keyboardType: TextInputType.text,
      isRequired: true,
      nextFocusNode: context.read<CreateDoctorCubit>().addressFocusNode,
      currentFocusNode: context.read<CreateDoctorCubit>().descriptionFocusNode,
      currentController:
          context.read<CreateDoctorCubit>().descriptionController,
    );
  }
}
