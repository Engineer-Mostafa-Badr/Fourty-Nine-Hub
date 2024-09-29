import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
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
                return DropdownMenu<CityEntity>(
                  inputDecorationTheme: InputDecorationTheme(
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
                    // Makes the input field more compact
                    constraints: BoxConstraints.loose(Size.fromHeight(90.h)),
                    // contentPadding: EdgeInsets.symmetric(
                    //   vertical: 0, // Set to zero to reduce height
                    //   horizontal:
                    //       10.w, // Keep horizontal padding for better appearance
                    // ),
                  ),
                  // Keeping the menuHeight the same since we're focusing on the widget's height
                  menuHeight: MediaQuery.of(context).size.height / 1.5,
                  menuStyle: const MenuStyle(
                    visualDensity: VisualDensity.comfortable,
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  hintText: LocaleKeys.selectCity.tr(),
                  dropdownMenuEntries: state.cities
                      .map((e) => DropdownMenuEntry(value: e, label: e.nameEn))
                      .toList(),
                  onSelected: (value) {
                    if (value != null) {
                      createRestaurantCubit.selectCity(value);
                    }
                  },
                );
              }),
              BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                  builder: (context, st) {
                return Visibility(
                  visible: st is ValidationState && (st.isCity ?? true),
                  child: const Padding(
                    padding: EdgeInsets.only(right: 5, left: 5, top: 5.0),
                    child: Text(
                      "You have to selecte your city!",
                      style: TextStyle(color: Colors.red),
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
