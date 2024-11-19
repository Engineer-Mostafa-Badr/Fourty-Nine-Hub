import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                return DropdownMenu<FoodCategoryEntity>(
                    inputDecorationTheme: InputDecorationTheme(
                      isDense: true,
                      constraints: BoxConstraints.loose(
                        Size.fromHeight(90.h),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                            color: st is ValidationState &&
                                    (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                            color: st is ValidationState &&
                                    (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.grey),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                            color: st is ValidationState &&
                                    (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.grey),
                      ),
                      // contentPadding: EdgeInsets.symmetric(
                      //   vertical: 5.h,
                      //   horizontal: 10.w,
                      // ),
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
                            label: (getLang() == "ar" ? e.nameAr : e.nameEn) ??
                                ""))
                        .toList(),
                    onSelected: (value) {
                      if (value != null) {
                        createResturantCubit.selectSubcategory(value);
                      }
                    });
              }),
              BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                  builder: (context, st) {
                return Visibility(
                  visible: st is ValidationState && (st.isSubCategory ?? true),
                  child: const Padding(
                    padding: EdgeInsets.only(right: 5, left: 5, top: 5.0),
                    child: Text(
                      "You have to choose your favorite subcategory!",
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
      listener: (BuildContext context, CreateRestaurantState state) {},
    );
  }
}
