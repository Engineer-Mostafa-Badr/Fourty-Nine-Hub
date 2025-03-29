import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/custom_text_field_health.dart';

class CreateDoctorWaitingTimeField extends StatelessWidget {
  const CreateDoctorWaitingTimeField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldHealth(
      hintText: '${LocaleKeys.waitingTime.localize}*',
      controller: context.read<CreateDoctorCubit>().waitingTimeController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return LocaleKeys.firstNameIsRequired.localize;
        }
        return null;
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}
