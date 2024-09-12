import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';

class CreateDoctorCitiesDropdowns extends StatelessWidget {
  const CreateDoctorCitiesDropdowns({super.key});

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      buildWhen: (previous, current) =>
          current is CreateDoctorCitiesLoaded ||
          current is CreateDoctorCitiesLoading,
      builder: (context, state) {
        if (state is CreateDoctorCitiesLoaded) {
          return DropdownMenu<CityEntity>(
              width: MediaQuery.of(context).size.width * 0.9,
              hintText: "City",
              dropdownMenuEntries: state.cities
                  .map((e) => DropdownMenuEntry(value: e, label: e.nameEn))
                  .toList(),
              onSelected: (value) {
                if (value != null) {
                  createDoctorCubit.selectCity(value);
                }
              });
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
