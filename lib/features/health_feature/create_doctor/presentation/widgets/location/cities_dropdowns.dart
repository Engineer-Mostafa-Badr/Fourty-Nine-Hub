import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';

class CreateDoctorCitiesDropdowns extends StatelessWidget {
  const CreateDoctorCitiesDropdowns({super.key});

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      builder: (context, state) {
        return DropdownMenu(
            width: MediaQuery.of(context).size.width * 0.9,
            hintText: "City",
            dropdownMenuEntries: state.cities
                .map((e) => DropdownMenuEntry(value: e, label: e))
                .toList(),
            onSelected: (value) {
              if (value != null) {
                createDoctorCubit.selectCity(value);
              }
            });
      },
    );
  }
}
