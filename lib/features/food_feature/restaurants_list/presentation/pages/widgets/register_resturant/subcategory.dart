import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_resturant_cubit.dart';

class CreateResturantSubcategoryDropdown extends StatelessWidget {
  const CreateResturantSubcategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final createResturantCubit = context.read<CreateRestaurantCubit>();
    return BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
      buildWhen: (previous, current) =>
          current is CreateResturantSubCategoriesLoaded,
      builder: (context, state) {
        if (state is CreateResturantSubCategoriesLoaded) {
          return DropdownMenu<FoodCategoryEntity>(
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
              hintText: LocaleKeys.selecteSubcategory.tr(),
              dropdownMenuEntries: state.subCategories
                  .map((e) => DropdownMenuEntry<FoodCategoryEntity>(
                      value: e,
                      label: (getLang() == "ar" ? e.nameAr : e.nameEn) ?? ""))
                  .toList(),
              onSelected: (value) {
                if (value != null) {
                  createResturantCubit.selectSubcategory(value);
                }
              });
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
