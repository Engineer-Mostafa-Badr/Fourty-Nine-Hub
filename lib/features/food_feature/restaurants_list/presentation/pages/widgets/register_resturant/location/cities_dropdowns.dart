import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

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
          return DropdownMenu<CityEntity>(
              inputDecorationTheme: const InputDecorationTheme(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
              ),
              menuHeight: MediaQuery.of(context).size.height / 1.5,
              menuStyle: const MenuStyle(
                visualDensity: VisualDensity.comfortable,
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              hintText: LocaleKeys.selectCity.localize,
              dropdownMenuEntries: state.cities
                  .map((e) => DropdownMenuEntry(value: e, label: e.nameEn))
                  .toList(),
              onSelected: (value) {
                if (value != null) {
                  createRestaurantCubit.selectCity(value);
                }
              });
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
