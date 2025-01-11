import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: st is ValidationState && (st.isCity ?? true)
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: st is ValidationState && (st.isCity ?? true)
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: st is ValidationState && (st.isCity ?? true)
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                    isDense: true,
                    constraints: BoxConstraints.loose(Size.fromHeight(90.h)),
                  ),
                  hint: Text(LocaleKeys.selectCity.tr()),
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
