import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorGovernorateDropdown extends StatelessWidget {
  const CreateDoctorGovernorateDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      buildWhen: (previous, current) =>
          current is CreateDoctorGovernorateLoaded,
      builder: (context, state) {
        if (state is CreateDoctorGovernorateLoaded) {
          return DropdownMenu(
              width: MediaQuery.of(context).size.width * 0.9,
              hintText: "Governorate",
              dropdownMenuEntries: state.governorates
                  .map((e) => DropdownMenuEntry(value: e, label: e))
                  .toList(),
              onSelected: (value) {
                if (value != null) {
                  createDoctorCubit.selectGovernorate(value);
                }
              });
        } else {
          return Text("can't load governorates", style: Styles.headerText());
        }
      },
    );
  }
}
