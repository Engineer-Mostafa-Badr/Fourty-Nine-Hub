import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

// ignore: must_be_immutable
class CreateDoctorOptionsCheckbox extends StatelessWidget {
  CreateDoctorOptionsCheckbox({super.key});

  bool _clinic = false;
  bool _call = false;
  bool _homeVisit = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
          buildWhen: (previous, current) =>
              current is CreateDoctorShowClinic ||
              current is CreateDoctorInitial,
          builder: (context, state) {
            return Checkbox(
              value: _clinic,
              onChanged: (value) {
                _clinic = value!;
                context.read<CreateDoctorCubit>().toggleClinic(value);
              },
            );
          },
        ),
        Text(
          'Clinic',
          style: Styles.mediumText(),
        ),
        Sizer(),
        BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
          buildWhen: (previous, current) =>
              current is CreateDoctorShowCall || current is CreateDoctorInitial,
          builder: (context, state) {
            return Checkbox(
              value: _call,
              onChanged: (value) {
                _call = value!;
                context.read<CreateDoctorCubit>().toggleCallCheck(value);
              },
            );
          },
        ),
        Text(
          'Call',
          style: Styles.mediumText(),
        ),
        Sizer(),
        BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
          buildWhen: (previous, current) =>
              current is CreateDoctorShowHomeVisit ||
              current is CreateDoctorInitial,
          builder: (context, state) {
            return Checkbox(
              value: _homeVisit,
              onChanged: (value) {
                _homeVisit = value!;
                context.read<CreateDoctorCubit>().toggleHomeVisit(value);
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
