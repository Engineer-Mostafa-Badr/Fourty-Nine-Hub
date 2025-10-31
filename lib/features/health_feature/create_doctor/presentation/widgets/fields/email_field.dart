import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/custom_text_field_health.dart';

class CreateDoctorEmailField extends StatelessWidget {
  const CreateDoctorEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorLoginCubit = context.read<CreateDoctorCubit>();
    return CustomTextFieldHealth(
      focusNode: doctorLoginCubit.emailFocusNode,
      hintText: LocaleKeys.email.localize,
      controller: doctorLoginCubit.emailController,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) => debugPrint('Email: $value'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.isArabic
              ? 'البريد الإلكتروني مطلوب'
              : 'Email is required';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return context.isArabic
              ? 'يرجى إدخال بريد إلكتروني صحيح'
              : 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}
