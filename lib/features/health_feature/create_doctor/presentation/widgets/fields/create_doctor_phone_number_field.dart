import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';

import '../../../../../../common/widgets/form/text_fields/new_phone_number_text_field.dart';

class CreateDoctorPhoneNumberField extends StatelessWidget {
  const CreateDoctorPhoneNumberField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NewPhoneNumberTextFormField(
      currentController: context.read<CreateDoctorCubit>().phoneController,
      keyboardType: TextInputType.number,
      isRequired: true,
      borderColor: const Color(0xffD9D9D9),
      fillColor: const Color(0xffD9D9D9),
    );
  }
}
