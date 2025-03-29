import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/custom_text_field_health.dart';

class CreateDoctorPhoneNumberField extends StatelessWidget {
  const CreateDoctorPhoneNumberField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldHealth(
      hintText: LocaleKeys.phoneNumber.localize,
      controller: context.read<CreateDoctorCubit>().phoneController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return LocaleKeys.phoneIsRequired.localize;
        }
        return null;
      },
    );
  }
}
