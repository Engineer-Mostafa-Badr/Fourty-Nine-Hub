import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/cubit/doctor_login_cubit.dart';

class DoctorLoginLocationField extends StatelessWidget {
  const DoctorLoginLocationField({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorLoginCubit = context.read<DoctorLoginCubit>();
    return DefaultTextFormField(
      currentFocusNode: doctorLoginCubit.locationFocusNode ,
      currentController: doctorLoginCubit.locationController,
      hint: 'Location',
      suffixIcon: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.location_on_outlined),
      ),
    );
  }
}
