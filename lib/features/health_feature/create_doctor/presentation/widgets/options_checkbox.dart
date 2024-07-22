import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorOptionsCheckbox extends StatefulWidget {
  const CreateDoctorOptionsCheckbox({super.key});

  @override
  State<CreateDoctorOptionsCheckbox> createState() =>
      _CreateDoctorOptionsCheckboxState();
}

class _CreateDoctorOptionsCheckboxState
    extends State<CreateDoctorOptionsCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
          builder: (context, state) {
            return Checkbox(
              value: state.hasClinic,
              onChanged: (value) {
                context.read<CreateDoctorCubit>().toggleClinic(value!);
              },
            );
          },
        ),
        Text(
          'Clinic',
          style: Styles.mediumText(),
        ),
        const Sizer(),
        BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
          builder: (context, state) {
            return Checkbox(
              value: state.hasCall,
              onChanged: (value) {
                context.read<CreateDoctorCubit>().toggleCallCheck(value!);
              },
            );
          },
        ),
        Text(
          'Call',
          style: Styles.mediumText(),
        ),
        const Sizer(),
        BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
          builder: (context, state) {
            return Checkbox(
              value: state.hasHomeVisit,
              onChanged: (value) {
                context.read<CreateDoctorCubit>().toggleHomeVisit(value!);
              },
            );
          },
        ),
        Text(
          'Home Visit',
          style: Styles.mediumText(),
        ),
      ],
    );
  }
}
