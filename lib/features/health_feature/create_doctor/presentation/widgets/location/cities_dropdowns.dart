import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorCitiesDropdowns extends StatelessWidget {
  const CreateDoctorCitiesDropdowns({super.key});

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      buildWhen: (previous, current) => current is CreateDoctorCityLoaded,
      builder: (context, state) {
        if (state is CreateDoctorCityLoaded) {
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
        } else {
          return Text("can't load cities", style: Styles.headerText());
        }
      },
    );
  }
}
