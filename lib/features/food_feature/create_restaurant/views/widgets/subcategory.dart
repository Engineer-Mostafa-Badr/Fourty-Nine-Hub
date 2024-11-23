import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateResturantSubcategoryDropdown extends StatelessWidget {
  const CreateResturantSubcategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final createResturantCubit = context.read<CreateRestaurantCubit>();
    return BlocConsumer<CreateRestaurantCubit, CreateRestaurantState>(
      buildWhen: (previous, current) =>
          current is CreateResturantSubCategoriesLoaded,
      builder: (context, state) {
        if (state is CreateResturantSubCategoriesLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                  builder: (context, st) {
                return DropdownButtonFormField<FoodCategoryEntity>(
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    isDense: true,
                    constraints: BoxConstraints.loose(
                      Size.fromHeight(90.h),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color:
                            st is ValidationState && (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color:
                            st is ValidationState && (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.grey,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color:
                            st is ValidationState && (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.grey,
                      ),
                    ),
                  ),
                  items: state.subCategories
                      .map((e) => DropdownMenuItem<FoodCategoryEntity>(
                          value: e,
                          child: Text(
                            (context.isArabic ? e.nameAr : e.nameEn) ?? "",
                            style: Styles
                                .mediumText(), // Add your desired text style here
                          )))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      createResturantCubit.selectSubcategory(value);
                    }
                  },
                  menuMaxHeight: MediaQuery.of(context).size.height / 1.5,
                  isExpanded: true,
                  hint: Text(
                    LocaleKeys.selecteSubcategory.tr(),
                    style: Styles
                        .mediumText(), // You can adjust this hint style as needed
                  ),
                );
              }),
              BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                  builder: (context, st) {
                return Visibility(
                  visible: st is ValidationState && (st.isSubCategory ?? true),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5, top: 5.0),
                    child: Text(
                      LocaleKeys.youHaveToChooseFavoriteSubcategory.localize,
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
      listener: (BuildContext context, CreateRestaurantState state) {},
    );
  }
}
