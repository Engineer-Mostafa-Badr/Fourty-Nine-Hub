import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateRestaurantGovernorateDropdown extends StatelessWidget {
  const CreateRestaurantGovernorateDropdown(
      {super.key, this.onSelected, this.validator});
  final void Function(GovernorateEntity? value)? onSelected;
  final String? Function(Object? value)? validator;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
      buildWhen: (previous, current) =>
          current is CreateRestaurantGovernoratesLoaded,
      builder: (context, state) {
        if (state is CreateRestaurantGovernoratesLoaded) {
          return FormField(
            validator: validator,
            builder: (field) {
              return Column(
                children: [
                  DropdownMenu(
                      menuHeight: MediaQuery.of(context).size.height / 1.5,
                      menuStyle: const MenuStyle(
                        visualDensity: VisualDensity.comfortable,
                      ),
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
