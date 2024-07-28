import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';

class CreateDoctorAddressField extends StatelessWidget {
  const CreateDoctorAddressField({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      hint: 'Address',
      keyboardType: TextInputType.text,
      isRequired: true,
      currentFocusNode: context.read<CreateDoctorCubit>().addressFocusNode,
      currentController: context.read<CreateDoctorCubit>().addressController,
    );
  }
}
