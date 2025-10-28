import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/utils/media_query_values.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../cubit/create_restaurant_cubit.dart';
import '../../../../../health_feature/create_doctor/domain/entities/city.dart';

import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class CreateRestaurantCitiesDropdowns extends StatelessWidget {
  const CreateRestaurantCitiesDropdowns({super.key});

  @override
  Widget build(BuildContext context) {
    final createRestaurantCubit = context.read<CreateRestaurantCubit>();
    return BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
      buildWhen: (previous, current) =>
          current is CreateRestaurantCitiesLoaded ||
          current is CreateRestaurantCitiesLoading,
      builder: (context, state) {
        if (state is CreateRestaurantCitiesLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                  builder: (context, st) {
                return DropdownButtonFormField<CityEntity>(
                  dropdownColor: AppColors.getFillColor(context),
                  icon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: AppColors.getTextColor(context),
                  ),
                  style:
                      Styles.mediumText(color: AppColors.getTextColor(context)),
                  decoration: InputDecoration(
                    fillColor: AppColors.getFillColor(context),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color:
                            st is ValidationState && (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.transparent,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color:
                            st is ValidationState && (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color:
                            st is ValidationState && (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.transparent,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color:
                            st is ValidationState && (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.transparent,
                      ),
                    ),
                    isDense: true,
                    constraints: BoxConstraints.loose(Size.fromHeight(90.h)),
                  ),
                  hint: Text(
                    LocaleKeys.selectCity.tr(),
                    style: Styles.mediumText(),
                  ),
                  menuMaxHeight: context.height / 2,
                  items: state.cities.map((e) {
                    return DropdownMenuItem<CityEntity>(
                      value: e,
                      child: Text(context.isArabic ? e.nameAr : e.nameEn),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      createRestaurantCubit.selectCity(value);
                    }
                  },
                  isExpanded:
                      true, // Ensures the dropdown takes up the available width
                );
              }),
              BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                  builder: (context, st) {
                return Visibility(
                  visible: st is ValidationState && (st.isCity ?? true),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5, top: 5.0),
                    child: Text(
                      LocaleKeys.youHaveToSelectYourCity.localize,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              })
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
