import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorGovernorateDropdown extends StatelessWidget {
  const CreateDoctorGovernorateDropdown(
      {super.key, this.onSelected, this.validator});
  final void Function(GovernorateEntity? value)? onSelected;
  final String? Function(Object? value)? validator;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      buildWhen: (previous, current) =>
          current is CreateDoctorGovernoratesLoaded,
      builder: (context, state) {
        if (state is CreateDoctorGovernoratesLoaded) {
          return FormField(
            validator: validator,
            builder: (field) {
              return Column(
                children: [
                  DropdownMenu(
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    field.hasError ? Colors.red : Colors.grey)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: field.hasError ? Colors.red : Colors.grey,
                        )),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: field.hasError ? Colors.red : Colors.grey,
                        )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: field.hasError ? Colors.red : Colors.grey,
                        )),
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      hintText: "Governorate",
                      dropdownMenuEntries: state.governorates
                          .map((e) =>
                              DropdownMenuEntry(value: e, label: e.nameEn))
                          .toList(),
                      onSelected: onSelected),
                  if (field.hasError)
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          field.errorText ?? "",
                          style: Styles.mediumText(color: Colors.red),
                        ),
                      ],
                    )
                ],
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
