import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_personal_info/edit_doctor_personal_info_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../../core/localization/locale_keys.g.dart';

class EditDoctorAddressField extends StatelessWidget {
  const EditDoctorAddressField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDoctorPersonalInfoCubit,
        EditDoctorPersonalInfoState>(builder: (context, state) {
      return Column(
        children: [
          // DropdownMenu(
          //   width: MediaQuery.of(context).size.width * 0.9,
          //   hintText: LocaleKeys.governorate.localize,
          //   dropdownMenuEntries: const [],
          //   onSelected: (value) {
          //     if (value != null) {}
          //   },
          // ),
          SizedBox(
            width: double.infinity,
            child: DropdownButtonFormField<GovernorateEntity>(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.grey, // Border color
                    width: 1.0, // Border width
                  ),
                ),
              ),
              hint: Text(LocaleKeys.selectGovernorate.localize),
              value: state.selectedGovernorateId != null
                  ? state.governorates?.firstWhereOrNull(
                      (element) => element.id == state.selectedGovernorateId)
                  : null,
              onChanged: (GovernorateEntity? newValue) {
                context
                    .read<EditDoctorPersonalInfoCubit>()
                    .onSelectGovernorate(newValue?.id ?? '');
                print("state.governorate${state.selectedGovernorateId}");
                print("state.city${state.selectedCityId}");
              },
              dropdownColor:
                  context.isDarkMode ? AppColors.DARK_GRAY_COLOR : Colors.white,
              items: state.governorates
                  ?.map<DropdownMenuItem<GovernorateEntity>>(
                      (GovernorateEntity government) {
                return DropdownMenuItem<GovernorateEntity>(
                  value: government,
                  child: Text(getLang() == 'ar'
                      ? government.nameAr
                      : government.nameEn), // Change to city.nameAr for Arabic
                );
              }).toList(),
            ),
          ),
          Sizer(
            height: 20.h,
          ),
          state.isLoadingCities
              ? const Center(child: CircularProgressIndicator())
              : (state.isLoadingCitiesSuccess ||
                      state.selectedGovernorateId != null)
                  ? SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<CityEntity>(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.grey, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                        ),
                        hint: Text(LocaleKeys.selectCity.localize),
                        value: state.selectedCityId != null
                            ? state.cities?.firstWhereOrNull(
                                (element) => element.id == state.selectedCityId)
                            : null,
                        onChanged: (CityEntity? newValue) {
                          print(newValue?.id);
                          context
                              .read<EditDoctorPersonalInfoCubit>()
                              .onSelectCity(newValue?.id ?? '');
                          print(
                              "state.governorate1${state.selectedGovernorateId}");
                          print("state.city${state.selectedCityId}");
                        },
                        dropdownColor: context.isDarkMode
                            ? AppColors.DARK_GRAY_COLOR
                            : Colors.white,
                        items: state.cities?.map<DropdownMenuItem<CityEntity>>(
                            (CityEntity city) {
                          return DropdownMenuItem<CityEntity>(
                            value: city,
                            child: Text(getLang() == 'ar'
                                ? city.nameAr
                                : city
                                    .nameEn), // Change to city.nameAr for Arabic
                          );
                        }).toList(),
                      ),
                    )
                  : const SizedBox.shrink(),
          Sizer(
            height: 20.h,
          ),
          DefaultTextFormField(
            hint: LocaleKeys.address.localize,
            keyboardType: TextInputType.text,
            isRequired: true,
            currentFocusNode: FocusNode(),
            currentController:
                context.read<EditDoctorPersonalInfoCubit>().addressController,
          ),
        ],
      );
    });
  }
}
