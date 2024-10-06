import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorSubmitButton extends StatelessWidget {
  const CreateDoctorSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedAppButton(
            onPressed: () {
              context.read<CreateDoctorCubit>().submit();
            },
            label: 'Submit',
            textStyle: Styles.headerText().copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
