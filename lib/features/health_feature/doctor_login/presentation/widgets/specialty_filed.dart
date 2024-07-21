import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/cubit/doctor_login_cubit.dart';

class DoctorLoginSpecialtyField extends StatelessWidget {
  const DoctorLoginSpecialtyField({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorLoginCubit = context.read<DoctorLoginCubit>();
    return DefaultTextFormField(
        currentFocusNode: doctorLoginCubit.specialtyFocusNode,
        currentController: doctorLoginCubit.specialtyController,
        hint: "Specialty");
  }
}
