import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/cubit/doctor_login_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorLoginOptionsCheckbox extends StatefulWidget {
  const DoctorLoginOptionsCheckbox({super.key});

  @override
  State<DoctorLoginOptionsCheckbox> createState() =>
      _DoctorLoginOptionsCheckboxState();
}

class _DoctorLoginOptionsCheckboxState
    extends State<DoctorLoginOptionsCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<DoctorLoginCubit, DoctorLoginState>(
          builder: (context, state) {
            return Checkbox(
              value: state.hasCall,
              onChanged: (value) {
                context.read<DoctorLoginCubit>().hasCallCheck(value!);
              },
            );
          },
        ),
        Text(
          'Call',
          style: Styles.mediumText(),
        ),
        const Sizer(),
        BlocBuilder<DoctorLoginCubit, DoctorLoginState>(
          builder: (context, state) {
            return Checkbox(
              value: state.hasHomeVisit,
              onChanged: (value) {
                context.read<DoctorLoginCubit>().hasHomeVisitCheck(value!);
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
