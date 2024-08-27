import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorGovernorateDropdown extends StatelessWidget {
  const CreateDoctorGovernorateDropdown({
    super.key,
    this.onSelected,
    this.validator,
    this.hintStyle,
  });
  final void Function(GovernorateEntity? value)? onSelected;
  final String? Function(Object? value)? validator;
  final TextStyle? hintStyle;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownMenu(
                      inputDecorationTheme: InputDecorationTheme(
                        hintStyle: hintStyle,
                        // hintStyle: TextStyle(fontSize: 17, color: Colors.red, fontWeight: FontWeight.w600),,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: field.hasError
                                    ? Colors.red
                                    : Colors.black)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: field.hasError ? Colors.red : Colors.black,
                            )),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: field.hasError ? Colors.red : Colors.black,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: field.hasError ? Colors.red : Colors.black,
                            )),
                      ),
                      width: MediaQuery.of(context).size.width * 0.95,
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            field.errorText ?? "",
                            style: Styles.mediumText(color: Colors.red),
                          ),
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
