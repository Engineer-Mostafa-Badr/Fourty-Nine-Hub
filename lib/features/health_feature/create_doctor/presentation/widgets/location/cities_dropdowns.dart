import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorCitiesDropdowns extends StatelessWidget {
  const CreateDoctorCitiesDropdowns({super.key, this.validator});
  final String? Function(Object? value)? validator;

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      buildWhen: (previous, current) =>
          current is CreateDoctorCitiesLoaded ||
          current is CreateDoctorCitiesLoading,
      builder: (context, state) {
        if (state is CreateDoctorCitiesLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${LocaleKeys.selectCity.localize}:",style: Styles.mediumText(),),
              FormField(
                  validator: validator,
                builder: (field) {
                  return DropdownMenu<CityEntity>(
                      inputDecorationTheme: InputDecorationTheme(
                        hintStyle: Styles.mediumText(),
                        // hintStyle: TextStyle(fontSize: 17, color: Colors.red, fontWeight: FontWeight.w600),,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color:
                                field.hasError ? Colors.red : Colors.grey)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: field.hasError ? Colors.red : Colors.grey,
                            )),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: field.hasError ? Colors.red : Colors.grey,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: field.hasError ? Colors.red : Colors.grey,
                            )),
                      ),
                      width: MediaQuery.of(context).size.width * 0.96,
                      hintText: LocaleKeys.city.localize,
                      dropdownMenuEntries: state.cities
                          .map((e) => DropdownMenuEntry(value: e, label: context.isArabic?e.nameAr:e.nameEn))
                          .toList(),
                      onSelected: (value) {
                        if (value != null) {
                          createDoctorCubit.selectCity(value);
                        }
                      });
                }
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
